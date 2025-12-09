//
//  RegisterViewController.swift
//  FitQuest
//
//  Created by Sunny Yadav on 11/17/25.
//

import UIKit
import PhotosUI

class RegisterViewController: UIViewController {
    
    // MARK: - Properties
    private let registerView = RegisterView()
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        return formatter
    }()
    
    private var pickedImage: UIImage?
    private let authService = AuthService.shared
    private let firestoreService = FirestoreService.shared
    private let storageService = StorageService.shared
    
    // MARK: - Lifecycle
    override func loadView() {
        view = registerView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
        setupActions()
        setupDelegates()
        hideKeyboardOnTapOutside()
        setupKeyboardObservers()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        view.endEditing(true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Setup
    private func setupViewController() {
        navigationItem.hidesBackButton = true
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func setupActions() {
        registerView.profileImageButton.menu = createImagePickerMenu()
        registerView.signUpButton.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        registerView.signInButton.addTarget(self, action: #selector(handleSignIn), for: .touchUpInside)
        registerView.datePicker.addTarget(self, action: #selector(datePickerChanged), for: .valueChanged)
    }
    
    private func setupDelegates() {
        registerView.nameTextField.delegate = self
        registerView.emailTextField.delegate = self
        registerView.passwordTextField.delegate = self
        registerView.dateOfBirthTextField.delegate = self
        
        // Set tint color for all text fields
        [registerView.nameTextField, registerView.emailTextField,
         registerView.passwordTextField, registerView.dateOfBirthTextField].forEach { textField in
            textField?.tintColor = UIColor(red: 0.33, green: 0.67, blue: 0.93, alpha: 1.0)
        }
    }
    
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillChangeFrame),
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil
        )
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        if keyboardFrame.height > 0 {
            let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height, right: 0)
            registerView.scrollView.contentInset = contentInsets
            registerView.scrollView.scrollIndicatorInsets = contentInsets
            scrollToActiveTextField()
        }
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.3) {
            self.registerView.scrollView.contentInset = .zero
            self.registerView.scrollView.scrollIndicatorInsets = .zero
        }
    }

    @objc private func keyboardWillChangeFrame(notification: NSNotification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        if keyboardFrame.height > 0 {
            let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height, right: 0)
            registerView.scrollView.contentInset = contentInsets
            registerView.scrollView.scrollIndicatorInsets = contentInsets
        } else {
            registerView.scrollView.contentInset = .zero
            registerView.scrollView.scrollIndicatorInsets = .zero
        }
    }
    
    private func scrollToActiveTextField() {
        var activeTextField: UITextField?
        
        if registerView.nameTextField.isFirstResponder {
            activeTextField = registerView.nameTextField
        } else if registerView.emailTextField.isFirstResponder {
            activeTextField = registerView.emailTextField
        } else if registerView.passwordTextField.isFirstResponder {
            activeTextField = registerView.passwordTextField
        } else if registerView.dateOfBirthTextField.isFirstResponder {
            activeTextField = registerView.dateOfBirthTextField
        }
        
        if let textField = activeTextField {
            let textFieldFrame = textField.convert(textField.bounds, to: registerView.scrollView)
            registerView.scrollView.scrollRectToVisible(textFieldFrame, animated: true)
        }
    }
    
    // MARK: - Date Picker
    @objc private func datePickerChanged() {
        let selectedDate = registerView.datePicker.date
        registerView.dateOfBirthTextField.text = dateFormatter.string(from: selectedDate)
    }
    
    // MARK: - Actions
    @objc private func handleSignUp() {
        view.endEditing(true)
        
        guard validateInputs() else { return }
        
        Task {
            await registerUser()
        }
    }
    
    @objc private func handleSignIn() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Validation
    private func validateInputs() -> Bool {
        guard let name = registerView.nameTextField.text, ValidationHelper.isValidName(name) else {
            showAlert(title: "Error", message: "Please enter your name.")
            return false
        }
        
        guard let email = registerView.emailTextField.text, ValidationHelper.isValidEmail(email) else {
            showAlert(title: "Invalid Email", message: "Please enter a valid email address.")
            return false
        }
        
        guard let password = registerView.passwordTextField.text else {
            showAlert(title: "Error", message: "Please enter a password.")
            return false
        }
        
        let passwordValidation = ValidationHelper.isValidPassword(password)
        guard passwordValidation.isValid else {
            showAlert(title: "Weak Password", message: passwordValidation.message ?? "Invalid password.")
            return false
        }
        
        guard let dateString = registerView.dateOfBirthTextField.text,
              let birthDate = dateFormatter.date(from: dateString),
              ValidationHelper.isValidAge(birthDate: birthDate) else {
            showAlert(title: "Age Restriction", message: "You must be at least 13 years old to register.")
            return false
        }
        
        return true
    }
    
    // MARK: - Registration Flow
    private func registerUser() async {
        guard let name = registerView.nameTextField.text,
              let email = registerView.emailTextField.text,
              let password = registerView.passwordTextField.text,
              let dateString = registerView.dateOfBirthTextField.text,
              let birthDate = dateFormatter.date(from: dateString) else {
            return
        }
        
        await MainActor.run { showLoadingIndicator() }
        
        do {
            // 1. Upload profile photo if available
            let photoURL = try await uploadProfilePhotoIfNeeded()
            
            // 2. Create Firebase Auth user
            let userId = try await authService.createUser(email: email, password: password)
            
            // 3. Update Auth profile
            try await authService.updateAuthProfile(userId: userId, name: name, photoURL: photoURL)
            
            // 4. Save user profile to Firestore
            try await firestoreService.saveUserProfile(
                userId: userId,
                name: name,
                email: email,
                dateOfBirth: birthDate,
                photoURL: photoURL
            )
            
            // 5. Create default settings
            try await firestoreService.createDefaultSettings(userId: userId)
            
            // 6. Create default stats
            try await firestoreService.createDefaultStats(userId: userId)
            
            // 7. Navigate to main screen
            await MainActor.run {
                hideLoadingIndicator()
                showSuccessAndNavigate()
            }
            
        } catch {
            await MainActor.run {
                hideLoadingIndicator()
                let errorMessage = FirebaseErrorHandler.getErrorMessage(from: error)
                showAlert(title: "Registration Failed", message: errorMessage)
            }
        }
    }
    
    private func uploadProfilePhotoIfNeeded() async throws -> URL? {
        guard let image = pickedImage else { return nil }
        
        do {
            let url = try await storageService.uploadProfileImage(image)
            return url
        } catch {
            // Log error but continue registration without photo
            print("Failed to upload profile photo: \(error.localizedDescription)")
            return nil
        }
    }
    
    // MARK: - Navigation
    private func showSuccessAndNavigate() {
        let alert = UIAlertController(
            title: "Welcome to FitQuest!",
            message: "Your account has been created successfully. Let's start your wellness journey!",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Let's Go!", style: .default) { [weak self] _ in
            self?.navigateToMainScreen()
        })
        
        present(alert, animated: true)
    }
    
    private func navigateToMainScreen() {
        clearTextFields()
        
        let homeVC = HomeScreenViewController()
        let navController = UINavigationController(rootViewController: homeVC)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true)
    }
    
    private func clearTextFields() {
        registerView.nameTextField.text = ""
        registerView.emailTextField.text = ""
        registerView.passwordTextField.text = ""
        registerView.dateOfBirthTextField.text = ""
    }
    
    // MARK: - Image Picker
    private func createImagePickerMenu() -> UIMenu {
        let menuItems = [
            UIAction(title: "Camera", image: UIImage(systemName: "camera")) { [weak self] _ in
                self?.presentCamera()
            },
            UIAction(title: "Gallery", image: UIImage(systemName: "photo.on.rectangle")) { [weak self] _ in
                self?.presentPhotoGallery()
            }
        ]
        
        return UIMenu(title: "Select Profile Photo", children: menuItems)
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
}

// MARK: - UITextFieldDelegate
extension RegisterViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Clear any stuck selection
        textField.selectedTextRange = nil
        
        // Scroll to field
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            self?.scrollToActiveTextField()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case registerView.nameTextField:
            registerView.emailTextField.becomeFirstResponder()
        case registerView.emailTextField:
            registerView.passwordTextField.becomeFirstResponder()
        case registerView.passwordTextField:
            registerView.dateOfBirthTextField.becomeFirstResponder()
        case registerView.dateOfBirthTextField:
            textField.resignFirstResponder()
            handleSignUp()
        default:
            textField.resignFirstResponder()
        }
        return true
    }
}

// MARK: - PHPickerViewControllerDelegate
extension RegisterViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        guard let itemProvider = results.first?.itemProvider,
              itemProvider.canLoadObject(ofClass: UIImage.self) else {
            return
        }
        
        itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
            DispatchQueue.main.async {
                if let image = image as? UIImage {
                    self?.updateProfileImage(image)
                }
            }
        }
    }
    
    private func updateProfileImage(_ image: UIImage) {
        registerView.profileImageButton.setImage(
            image.withRenderingMode(.alwaysOriginal),
            for: .normal
        )
        registerView.profileImageButton.imageView?.contentMode = .scaleAspectFill
        pickedImage = image
    }
}

// MARK: - UIImagePickerControllerDelegate
extension RegisterViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                              didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        let image = (info[.editedImage] as? UIImage) ?? (info[.originalImage] as? UIImage)
        
        if let image = image {
            updateProfileImage(image)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

// MARK: - Keyboard Protocol
extension RegisterViewController: KeyboardProtocol {
    func hideKeyboardOnTapOutside() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardOnTap))
        tapRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapRecognizer)
    }

    @objc func hideKeyboardOnTap() {
        view.endEditing(true)
    }
}

// MARK: - Alert Protocol
extension RegisterViewController: AlertProtocol {
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - Loading Indicator Protocol
extension RegisterViewController: LoadingIndicatorProtocol {
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
