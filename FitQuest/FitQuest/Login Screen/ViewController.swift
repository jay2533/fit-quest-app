//
//  ViewController.swift
//  FitQuest
//
//  Created by Sunny Yadav on 11/17/25.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {
    
    private let loginView = LoginView()
    private let authService = AuthService.shared
    
    override func loadView() {
        view = loginView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
        setupActions()
        setupDelegates()
        hideKeyboardOnTapOutside()
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
    
    private func setupViewController() {
        navigationItem.hidesBackButton = true
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func setupActions() {
        loginView.signInButton.addTarget(self, action: #selector(handleSignIn), for: .touchUpInside)
        loginView.forgotPasswordButton.addTarget(self, action: #selector(handleForgotPassword), for: .touchUpInside)
        loginView.registerButton.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
    }
    
    private func setupDelegates() {
        loginView.emailTextField.delegate = self
        loginView.passwordTextField.delegate = self
    }
    
    @objc private func handleSignIn() {
        view.endEditing(true)
        
        guard let email = loginView.emailTextField.text, !email.isEmpty else {
            showAlert(title: "Error", message: "Please enter your email.")
            return
        }
        
        guard let password = loginView.passwordTextField.text, !password.isEmpty else {
            showAlert(title: "Error", message: "Please enter your password.")
            return
        }
        
        guard ValidationHelper.isValidEmail(email) else {
            showAlert(title: "Invalid Email", message: "Please enter a valid email address.")
            return
        }
        
        signIn(email: email, password: password)
    }
    
    @objc private func handleForgotPassword() {
        let forgotPasswordVC = ForgotPasswordViewController()
        navigationController?.pushViewController(forgotPasswordVC, animated: true)
    }
    
    @objc private func handleRegister() {
        let registerVC = RegisterViewController()
        navigationController?.pushViewController(registerVC, animated: true)
    }
    
    private func signIn(email: String, password: String) {
        showLoadingIndicator()
        
        Task {
            do {
                try await authService.signIn(email: email, password: password)
                await MainActor.run {
                    hideLoadingIndicator()
                    navigateToMainScreen()
                }
            } catch {
                await MainActor.run {
                    hideLoadingIndicator()
                    let errorMessage = FirebaseErrorHandler.getErrorMessage(from: error)
                    showAlert(title: "Login Failed", message: errorMessage)
                }
            }
        }
    }
    
    private func sendPasswordReset(email: String) {
        showLoadingIndicator()
        
        Task {
            do {
                try await authService.sendPasswordReset(email: email)
                await MainActor.run {
                    hideLoadingIndicator()
                    showAlert(title: "Success", message: "Password reset email sent! Please check your inbox.")
                }
            } catch {
                await MainActor.run {
                    hideLoadingIndicator()
                    let errorMessage = FirebaseErrorHandler.getErrorMessage(from: error)
                    showAlert(title: "Reset Failed", message: errorMessage)
                }
            }
        }
    }
    
    private func navigateToMainScreen() {
        loginView.emailTextField.text = ""
        loginView.passwordTextField.text = ""
        
        let homeVC = HomeScreenViewController()
        let navController = UINavigationController(rootViewController: homeVC)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true)
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == loginView.emailTextField {
            loginView.passwordTextField.becomeFirstResponder()
        } else if textField == loginView.passwordTextField {
            textField.resignFirstResponder()
            handleSignIn()
        }
        return true
    }
}

extension ViewController: KeyboardProtocol {
    func hideKeyboardOnTapOutside() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardOnTap))
        tapRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapRecognizer)
    }

    @objc func hideKeyboardOnTap() {
        view.endEditing(true)
    }
}

extension ViewController: AlertProtocol {
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension ViewController: LoadingIndicatorProtocol {
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
