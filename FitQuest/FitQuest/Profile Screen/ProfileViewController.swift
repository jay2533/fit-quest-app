//
//  ProfileViewController.swift
//  FitQuest
//
//  Created by Sunny Yadav on 12/4/25.
//


import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import PhotosUI

class ProfileViewController: UIViewController {
    
    private let profileView = ProfileView()
    private let authService = AuthService.shared
    private let firestoreService = FirestoreService.shared
    private let database = Firestore.firestore()
    private let storageService = StorageService.shared
    private var currentUser: User?
    private var pickedImage: UIImage?
    
    override func loadView() {
        view = profileView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
        setupActions()

        setupNetworkListener()
        
        if NetworkManager.shared.isConnected {
            loadUserData()
        } else {
            showOfflineBanner()
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    private func setupViewController() {
        navigationItem.hidesBackButton = true
    }
    
    private func setupNetworkListener() {
        NetworkManager.shared.onNetworkStatusChanged = { [weak self] isConnected in
            if isConnected {
                self?.hideOfflineBanner()
                self?.loadUserData()  // Auto-reload when connection returns
            } else {
                self?.showOfflineBanner()
            }
        }
    }
    
    private func setupActions() {
        profileView.backButton.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        profileView.nameEditButton.addTarget(self, action: #selector(handleEditName), for: .touchUpInside)
        profileView.dobEditButton.addTarget(self, action: #selector(handleEditDOB), for: .touchUpInside)
        profileView.logoutButton.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
        profileView.deleteAccountButton.addTarget(self, action: #selector(handleDeleteAccount), for: .touchUpInside)
        profileView.userImageButton.menu = createImagePickerMenu()
    }
    
    private func loadUserData() {
        guard let userId = authService.currentUserId else {
            showAlert(title: "Error", message: "No user logged in")
            return
        }
        
        Task {
            do {
                // Fetch user profile from Firestore
                let document = try await database.collection("users").document(userId).getDocument()
                
                guard let data = document.data() else {
                    await MainActor.run {
                        showAlert(title: "Error", message: "Failed to load user data")
                    }
                    return
                }
                
                await MainActor.run {
                    self.displayUserData(data: data)
                }
                
            } catch {
                await MainActor.run {
                    showAlert(title: "Error", message: "Failed to load profile: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func displayUserData(data: [String: Any]) {
        if let name = data["name"] as? String {
            profileView.nameValueLabel.text = name
        }
        
        if let email = data["email"] as? String {
            profileView.emailValueLabel.text = email
        }
        
        if let dobTimestamp = data["dateOfBirth"] as? Timestamp {
            let dob = dobTimestamp.dateValue()
            profileView.dobValueLabel.text = DateFormatter.dayMonthYear.string(from: dob)
        } else {
            profileView.dobValueLabel.text = "Not set"
        }
        
        if let xp = data["totalXP"] as? Int {
            profileView.xpValueLabel.text = "\(xp)"
        }
        
        if let level = data["currentLevel"] as? Int {
            profileView.levelValueLabel.text = "\(level)"
        }
        
        if let tier = data["currentTier"] as? Int {
            let tierText = tier == 1 ? "I" : tier == 2 ? "II" : "III"
            profileView.tierValueLabel.text = tierText
        }
        
        if let imageURL = data["profileImageURL"] as? String, !imageURL.isEmpty {
            loadProfileImage(from: imageURL)
        }
        
        generateAIAvatar()
    }
    
    private func createImagePickerMenu() -> UIMenu {
        let menuItems = [
            UIAction(title: "Camera", image: UIImage(systemName: "camera")) { [weak self] _ in
                self?.presentCamera()
            },
            UIAction(title: "Gallery", image: UIImage(systemName: "photo.on.rectangle")) { [weak self] _ in
                self?.presentPhotoGallery()
            }
        ]
        
        return UIMenu(title: "Update Profile Photo", children: menuItems)
    }
    
    private func presentCamera() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            showAlert(title: "Camera Unavailable", message: "Camera is not available on this device.")
            return
        }
        
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    private func presentPhotoGallery() {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 1
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }

    private func updateProfileImage(_ image: UIImage) {
        guard let userId = authService.currentUserId else { return }
        
        showLoadingIndicator()
        
        Task {
            do {
                // 1. Upload new image to Firebase Storage
                let imageURL = try await storageService.uploadProfileImage(image)
                
                // 2. Delete old image if exists
                if let oldURLString = currentUser?.profileImageURL,
                   !oldURLString.isEmpty {
                    try? await storageService.deleteProfileImage(url: oldURLString)
                }
                
                // 3. Update Firestore with new URL
                try await database.collection("users").document(userId).updateData([
                    "profileImageURL": imageURL.absoluteString,
                    "lastActive": FieldValue.serverTimestamp()
                ])
                
                // 4. Update Auth profile
                if let user = Auth.auth().currentUser {
                    let changeRequest = user.createProfileChangeRequest()
                    changeRequest.photoURL = imageURL
                    try await changeRequest.commitChanges()
                }
                
                await MainActor.run {
                    hideLoadingIndicator()
                    
                    // Update UI
                    profileView.userImageButton.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
                    profileView.userImageButton.imageView?.contentMode = .scaleAspectFill
                    
                    showAlert(title: "Success", message: "Profile photo updated successfully")
                }
                
            } catch {
                await MainActor.run {
                    hideLoadingIndicator()
                    showAlert(title: "Error", message: "Failed to update profile photo: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func loadProfileImage(from urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                if let image = UIImage(data: data) {
                    await MainActor.run {
                        profileView.userImageButton.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
                        profileView.userImageButton.imageView?.contentMode = .scaleAspectFill

                    }
                }
            } catch {
                print("Failed to load profile image: \(error.localizedDescription)")
            }
        }
    }
    
    @objc private func handleBack() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func handleEditName() {
        showEditAlert(
            title: "Edit Name",
            message: "Enter your new name",
            currentValue: profileView.nameValueLabel.text ?? "",
            fieldType: .name
        ) { [weak self] newValue in
            self?.updateUserField(field: "name", value: newValue)
        }
    }
    
    @objc private func handleEditDOB() {
        showDatePickerAlert { [weak self] selectedDate in
            self?.updateUserField(field: "dateOfBirth", value: Timestamp(date: selectedDate))
        }
    }
    
    @objc private func handleLogout() {
        let alert = UIAlertController(
            title: "Logout",
            message: "Are you sure you want to logout?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        alert.addAction(UIAlertAction(title: "Logout", style: .destructive) { [weak self] _ in
            self?.performLogout()
        })
        
        present(alert, animated: true)
    }
    
    @objc private func handleDeleteAccount() {
        let alert = UIAlertController(
            title: "Delete Account",
            message: "Are you sure you want to delete your account? This action cannot be undone and all your data will be permanently deleted.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        alert.addAction(UIAlertAction(title: "Yes, Delete", style: .destructive) { [weak self] _ in
            self?.performAccountDeletion()
        })
        
        present(alert, animated: true)
    }
    
    private func performLogout() {
        guard let userId = authService.currentUserId else { return }
        
        // Clear notification read states
        NotificationStateManager.shared.clearAllReadStates(userId: userId)
        
        do {
            try authService.signOut()
            navigateToLogin()
        } catch {
            showAlert(title: "Error", message: "Failed to logout: \(error.localizedDescription)")
        }
    }
    
    private func navigateToLogin() {
        let loginVC = ViewController()
        let navController = UINavigationController(rootViewController: loginVC)
        navController.modalPresentationStyle = .fullScreen
        
        if let window = view.window {
            window.rootViewController = navController
            UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil)
        }
    }
    
    private func performAccountDeletion() {
        guard let userId = authService.currentUserId,
              let user = Auth.auth().currentUser else {
            showAlert(title: "Error", message: "No user logged in")
            return
        }
        
        showLoadingIndicator()
        
        Task {
            do {
                // 1. Delete user data from Firestore
                try await deleteUserData(userId: userId)
                
                // 2. Delete user tasks
                try await deleteUserTasks(userId: userId)
                
                // 3. Delete user stats
                try await deleteUserStats(userId: userId)
                
                // 4. Delete profile image from Storage (if exists)
                if let imageURL = currentUser?.profileImageURL, !imageURL.isEmpty {
                    try? await StorageService.shared.deleteProfileImage(url: imageURL)
                }
                
                // 5. Delete Firebase Auth account
                try await user.delete()
                
                await MainActor.run {
                    hideLoadingIndicator()
                    showAccountDeletedAlert()
                }
                
            } catch {
                await MainActor.run {
                    hideLoadingIndicator()
                    let errorMessage = FirebaseErrorHandler.getErrorMessage(from: error)
                    showAlert(title: "Deletion Failed", message: errorMessage)
                }
            }
        }
    }
    
    private func deleteUserData(userId: String) async throws {
        // Delete user profile
        try await database.collection("users").document(userId).delete()
        
        // Delete user settings
        let settingsSnapshot = try await database.collection("users")
            .document(userId)
            .collection("settings")
            .getDocuments()
        
        for doc in settingsSnapshot.documents {
            try await doc.reference.delete()
        }
    }
    
    private func deleteUserTasks(userId: String) async throws {
        let tasksSnapshot = try await database.collection("tasks")
            .whereField("userId", isEqualTo: userId)
            .getDocuments()
        
        for doc in tasksSnapshot.documents {
            try await doc.reference.delete()
        }
    }
    
    private func deleteUserStats(userId: String) async throws {
        // Delete overall stats
        let overallSnapshot = try await database.collection("stats")
            .document(userId)
            .collection("overall")
            .getDocuments()
        
        for doc in overallSnapshot.documents {
            try await doc.reference.delete()
        }
        
        // Delete category stats
        let categorySnapshot = try await database.collection("stats")
            .document(userId)
            .collection("categoryStats")
            .getDocuments()
        
        for doc in categorySnapshot.documents {
            try await doc.reference.delete()
        }
        
        // Delete progress trends
        let progressSnapshot = try await database.collection("stats")
            .document(userId)
            .collection("progressTrends")
            .getDocuments()
        
        for doc in progressSnapshot.documents {
            try await doc.reference.delete()
        }
        
        // Delete stats document
        try await database.collection("stats").document(userId).delete()
    }
    
    private func showAccountDeletedAlert() {
        let alert = UIAlertController(
            title: "Account Deleted",
            message: "Your account has been permanently deleted.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.navigateToLogin()
        })
        
        present(alert, animated: true)
    }
    
    private func updateUserField(field: String, value: Any) {
        guard let userId = authService.currentUserId else { return }
        
        showLoadingIndicator()
        
        Task {
            do {
                try await database.collection("users").document(userId).updateData([
                    field: value,
                    "lastActive": FieldValue.serverTimestamp()
                ])
                
                await MainActor.run {
                    hideLoadingIndicator()
                    loadUserData() // Refresh display
                    showAlert(title: "Success", message: "Profile updated successfully")
                }
                
            } catch {
                await MainActor.run {
                    hideLoadingIndicator()
                    showAlert(title: "Error", message: "Failed to update profile")
                }
            }
        }
    }
    
    private func showEditAlert(title: String, message: String, currentValue: String,
                              fieldType: UITextContentType, completion: @escaping (String) -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.text = currentValue
            textField.textContentType = fieldType
            textField.autocapitalizationType = fieldType == .name ? .words : .none
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        alert.addAction(UIAlertAction(title: "Save", style: .default) { _ in
            if let newValue = alert.textFields?.first?.text, !newValue.isEmpty {
                completion(newValue)
            }
        })
        
        present(alert, animated: true)
    }
    
    private func showDatePickerAlert(completion: @escaping (Date) -> Void) {
        let alert = UIAlertController(title: "Edit Date of Birth", message: "\n\n\n\n\n\n\n\n", preferredStyle: .alert)
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.maximumDate = Date()
        
        var dateComponents = DateComponents()
        dateComponents.year = -13
        datePicker.maximumDate = Calendar.current.date(byAdding: dateComponents, to: Date())
        
        dateComponents.year = -100
        datePicker.minimumDate = Calendar.current.date(byAdding: dateComponents, to: Date())
        
        datePicker.frame = CGRect(x: 10, y: 50, width: 250, height: 150)
        alert.view.addSubview(datePicker)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        alert.addAction(UIAlertAction(title: "Save", style: .default) { _ in
            completion(datePicker.date)
        })
        
        present(alert, animated: true)
    }
    
    private func generateAIAvatar() {
        guard let name = profileView.nameValueLabel.text else { return }
        
        Task {
            // Use shared avatar generator (same as home screen)
            let avatar = await AvatarGenerator.shared.getAIAvatar(name: name, size: 120)
            
            await MainActor.run {
                profileView.aiAvatarImageView.image = avatar
            }
        }
    }
}

extension ProfileViewController: AlertProtocol {
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension ProfileViewController: LoadingIndicatorProtocol {
    func showLoadingIndicator() {
        hideLoadingIndicator()
        
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.tag = 999
        indicator.color = .systemBlue
        indicator.center = view.center
        indicator.startAnimating()
        view.addSubview(indicator)
        view.isUserInteractionEnabled = false
    }
    
    func hideLoadingIndicator() {
        if let indicator = view.viewWithTag(999) as? UIActivityIndicatorView {
            indicator.stopAnimating()
            indicator.removeFromSuperview()
            view.isUserInteractionEnabled = true
        }
    }
}

// MARK: - PHPickerViewControllerDelegate
extension ProfileViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        guard let itemProvider = results.first?.itemProvider,
              itemProvider.canLoadObject(ofClass: UIImage.self) else {
            return
        }
        
        itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
            DispatchQueue.main.async {
                if let image = image as? UIImage {
                    self?.pickedImage = image
                    self?.updateProfileImage(image)
                }
            }
        }
    }
}

// MARK: - UIImagePickerControllerDelegate
extension ProfileViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                              didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        let image = (info[.editedImage] as? UIImage) ?? (info[.originalImage] as? UIImage)
        
        if let image = image {
            pickedImage = image
            updateProfileImage(image)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

extension ProfileViewController: NetworkCheckable {}

