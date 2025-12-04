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

class ProfileViewController: UIViewController {
    
    // MARK: - Properties
    private let profileView = ProfileView()
    private let authService = AuthService.shared
    private let firestoreService = FirestoreService.shared
    private let database = Firestore.firestore()
    
    private var currentUser: User?
    
    // MARK: - Lifecycle
    override func loadView() {
        view = profileView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
        setupActions()
        loadUserData()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    // MARK: - Setup
    private func setupViewController() {
        navigationItem.hidesBackButton = true
    }
    
    private func setupActions() {
        profileView.backButton.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        profileView.nameEditButton.addTarget(self, action: #selector(handleEditName), for: .touchUpInside)
        profileView.dobEditButton.addTarget(self, action: #selector(handleEditDOB), for: .touchUpInside)
        profileView.logoutButton.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
        profileView.deleteAccountButton.addTarget(self, action: #selector(handleDeleteAccount), for: .touchUpInside)
    }
    
    // MARK: - Load User Data
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
        // Name
        if let name = data["name"] as? String {
            profileView.nameValueLabel.text = name
        }
        
        // Email
        if let email = data["email"] as? String {
            profileView.emailValueLabel.text = email
        }
        
        // Date of Birth
        if let dobTimestamp = data["dateOfBirth"] as? Timestamp {
            let dob = dobTimestamp.dateValue()
            profileView.dobValueLabel.text = DateFormatter.dayMonthYear.string(from: dob)
        } else {
            profileView.dobValueLabel.text = "Not set"
        }
        
        // XP
        if let xp = data["totalXP"] as? Int {
            profileView.xpValueLabel.text = "\(xp)"
        }
        
        // Level
        if let level = data["currentLevel"] as? Int {
            profileView.levelValueLabel.text = "\(level)"
        }
        
        // Tier
        if let tier = data["currentTier"] as? Int {
            let tierText = tier == 1 ? "I" : tier == 2 ? "II" : "III"
            profileView.tierValueLabel.text = tierText
        }
        
        // Profile Image
        if let imageURL = data["profileImageURL"] as? String, !imageURL.isEmpty {
            loadProfileImage(from: imageURL)
        }
        
        // AI Avatar (placeholder for now)
        // TODO: Generate AI avatar based on user data
        generateAIAvatar()
    }
    
    private func loadProfileImage(from urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                if let image = UIImage(data: data) {
                    await MainActor.run {
                        profileView.userImageView.image = image
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
    
    // MARK: - Logout
    private func performLogout() {
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
    
    // MARK: - Edit User Fields
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
    
    // MARK: - Edit Alerts
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
        
        // Using DiceBear API (free)
        let encodedName = name.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "user"
        let avatarURL = "https://api.dicebear.com/7.x/avataaars/png?seed=\(encodedName)"
        
        guard let url = URL(string: avatarURL) else { return }
        
        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                if let image = UIImage(data: data) {
                    await MainActor.run {
                        profileView.aiAvatarImageView.image = image
                    }
                }
            } catch {
                print("Failed to generate AI avatar: \(error.localizedDescription)")
            }
        }
    }
}

// MARK: - Alert Protocol
extension ProfileViewController: AlertProtocol {
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - Loading Indicator Protocol
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
