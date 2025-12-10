//
//  ForgotPasswordViewController.swift
//  FitQuest
//
//  Created by Sunny Yadav on 12/2/25.
//

import UIKit
import FirebaseAuth

class ForgotPasswordViewController: UIViewController {
    
    private let forgotPasswordView = ForgotPasswordView()
    private let authService = AuthService.shared
    
    override func loadView() {
        view = forgotPasswordView
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
    }
    
    private func setupActions() {
        forgotPasswordView.sendOTPButton.addTarget(self, action: #selector(handleSendResetLink), for: .touchUpInside)
        forgotPasswordView.backToLoginButton.addTarget(self, action: #selector(handleBackToLogin), for: .touchUpInside)
    }
    
    private func setupDelegates() {
        forgotPasswordView.emailTextField.delegate = self
    }
    
    @objc private func handleSendResetLink() {
        view.endEditing(true)
        
        guard let email = forgotPasswordView.emailTextField.text, !email.isEmpty else {
            showAlert(title: "Email Required", message: "Please enter your email address.")
            return
        }
        
        guard ValidationHelper.isValidEmail(email) else {
            showAlert(title: "Invalid Email", message: "Please enter a valid email address.")
            return
        }
        
        sendPasswordResetLink(email: email)
    }
    
    @objc private func handleBackToLogin() {
        navigationController?.popViewController(animated: true)
    }
    
    private func sendPasswordResetLink(email: String) {
        showLoadingIndicator()
        
        Task {
            do {
                try await authService.sendPasswordReset(email: email)
                
                await MainActor.run {
                    hideLoadingIndicator()
                    showSuccessAlert(email: email)
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
    
    private func showSuccessAlert(email: String) {
        let alert = UIAlertController(
            title: "Check Your Email",
            message: "We've sent a password reset link to \(email). Please check your inbox and follow the instructions to reset your password.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        })
        
        present(alert, animated: true)
    }
}

extension ForgotPasswordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        handleSendResetLink()
        return true
    }
}

extension ForgotPasswordViewController: KeyboardProtocol {
    func hideKeyboardOnTapOutside() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardOnTap))
        tapRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapRecognizer)
    }

    @objc func hideKeyboardOnTap() {
        view.endEditing(true)
    }
}

extension ForgotPasswordViewController: AlertProtocol {
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension ForgotPasswordViewController: LoadingIndicatorProtocol {
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
