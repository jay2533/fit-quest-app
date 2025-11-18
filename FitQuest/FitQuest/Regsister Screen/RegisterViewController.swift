//
//  RegisterViewController.swift
//  FitQuest
//
//  Created by Sunny Yadav on 11/17/25.
//

import UIKit

class RegisterViewController: UIViewController {
    
    let registerView = RegisterView()
    let dateFormatter = DateFormatter()
    
    override func loadView() {
        view = registerView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hide navigation bar for this screen
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        // Setup date formatter
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        // Add button actions
        registerView.signUpButton.addTarget(self, action: #selector(onSignUpTapped), for: .touchUpInside)
        registerView.signInButton.addTarget(self, action: #selector(onSignInTapped), for: .touchUpInside)
        
        // Add date picker action
        registerView.datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        
        // Add tap gesture to dismiss keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        // Set text field delegates
        registerView.nameTextField.delegate = self
        registerView.usernameTextField.delegate = self
        registerView.passwordTextField.delegate = self
        registerView.emailTextField.delegate = self
        registerView.dateOfBirthTextField.delegate = self
        
        // Setup keyboard notifications
        setupKeyboardNotifications()
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
    }
    
    func setupKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
            registerView.scrollView.contentInset = contentInsets
            registerView.scrollView.scrollIndicatorInsets = contentInsets
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        registerView.scrollView.contentInset = .zero
        registerView.scrollView.scrollIndicatorInsets = .zero
    }
    
    @objc func dateChanged() {
        let selectedDate = registerView.datePicker.date
        registerView.dateOfBirthTextField.text = dateFormatter.string(from: selectedDate)
    }
    
    @objc func onSignUpTapped() {
        // Dismiss keyboard
        view.endEditing(true)
        
        // Get values
        let name = registerView.nameTextField.text ?? ""
        let username = registerView.usernameTextField.text ?? ""
        let password = registerView.passwordTextField.text ?? ""
        let email = registerView.emailTextField.text ?? ""
        let dateOfBirth = registerView.dateOfBirthTextField.text ?? ""
        
        // Basic validation
        if name.isEmpty {
            showAlert(title: "Error", message: "Please enter your name")
            return
        }
        
        if username.isEmpty {
            showAlert(title: "Error", message: "Please enter a username")
            return
        }
        
        if password.isEmpty {
            showAlert(title: "Error", message: "Please enter a password")
            return
        }
        
        if password.count < 6 {
            showAlert(title: "Error", message: "Password must be at least 6 characters")
            return
        }
        
        if email.isEmpty {
            showAlert(title: "Error", message: "Please enter your email")
            return
        }
        
        if !isValidEmail(email) {
            showAlert(title: "Error", message: "Please enter a valid email address")
            return
        }
        
        if dateOfBirth.isEmpty {
            showAlert(title: "Error", message: "Please select your date of birth")
            return
        }
        
        print("Sign Up tapped with:")
        print("Name: \(name)")
        print("Username: \(username)")
        print("Email: \(email)")
        print("Date of Birth: \(dateOfBirth)")
        
        // TODO: Implement sign up logic
        // TODO: Navigate to main app screen after successful registration
        showAlert(title: "Success", message: "Registration successful! (This is a placeholder)")
    }
    
    @objc func onSignInTapped() {
        // Pop back to the previous screen or navigate to sign in
        if let _ = navigationController?.viewControllers.first(where: { $0 is ViewController }) {
            // If SignInViewController exists in the stack, pop to it
            navigationController?.popViewController(animated: true)
        } else {
            // Otherwise, create and push a new SignInViewController
            let loginVC = ViewController()
            navigationController?.pushViewController(loginVC, animated: true)
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - UITextFieldDelegate
extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case registerView.nameTextField:
            registerView.usernameTextField.becomeFirstResponder()
        case registerView.usernameTextField:
            registerView.passwordTextField.becomeFirstResponder()
        case registerView.passwordTextField:
            registerView.emailTextField.becomeFirstResponder()
        case registerView.emailTextField:
            registerView.dateOfBirthTextField.becomeFirstResponder()
        case registerView.dateOfBirthTextField:
            textField.resignFirstResponder()
            onSignUpTapped()
        default:
            textField.resignFirstResponder()
        }
        return true
    }
}
