//
//  ViewController.swift
//  FitQuest
//
//  Created by Sunny Yadav on 11/17/25.
//

import UIKit

class ViewController: UIViewController {
    
    let loginView = LoginView()
    
    override func loadView() {
        view = loginView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hide navigation bar for this screen
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        // Add button actions
        loginView.signInButton.addTarget(self, action: #selector(onSignInTapped), for: .touchUpInside)
        loginView.forgotPasswordButton.addTarget(self, action: #selector(onForgotPasswordTapped), for: .touchUpInside)
        
        // Add navigation to register screen
        loginView.registerButton.addTarget(self, action: #selector(onRegisterTapped), for: .touchUpInside)
        
        // Add tap gesture to dismiss keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        // Set text field delegates if needed
        loginView.emailTextField.delegate = self
        loginView.passwordTextField.delegate = self
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
    
    @objc func onSignInTapped() {
        // Dismiss keyboard
        view.endEditing(true)
        
        // Get values
        let email = loginView.emailTextField.text ?? ""
        let password = loginView.passwordTextField.text ?? ""
        
        // Basic validation
        if email.isEmpty {
            showAlert(title: "Error", message: "Please enter your email")
            return
        }
        
        if password.isEmpty {
            showAlert(title: "Error", message: "Please enter your password")
            return
        }
        
        print("Sign In tapped with email: \(email)")
        // TODO: Yet to implement sign in logic
        // TODO: Navigate to main app screen after successful login
//        let calendarVC = CalendarScreenViewController()
//        navigationController?.pushViewController(calendarVC, animated: true)
    }
    
    @objc func onForgotPasswordTapped() {
        print("Forgot password tapped")
        // TODO: Navigate to forgot password screen or show reset password flow
        showAlert(title: "Forgot Password", message: "Password reset functionality will be implemented")
    }
    
    @objc func onRegisterTapped() {
        print("Register button tapped")
        // Navigate to RegisterViewController
        let registerVC = RegisterViewController()
        navigationController?.pushViewController(registerVC, animated: true)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UITextFieldDelegate
extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == loginView.emailTextField {
            loginView.passwordTextField.becomeFirstResponder()
        } else if textField == loginView.passwordTextField {
            textField.resignFirstResponder()
            onSignInTapped()
        }
        return true
    }
}
