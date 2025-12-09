//
//  LoginView.swift
//  FitQuest
//
//  Created by Sunny Yadav on 11/17/25.
//

import UIKit

class LoginView: UIView {
    
    var scrollView: UIScrollView!
    var contentView: UIView!
    
    var logoImageView: UIImageView!
    var appNameLabel: UILabel!
    var emailTextField: UITextField!
    var passwordTextField: UITextField!
    var signInButton: UIButton!
    var forgotPasswordButton: UIButton!
    var dontHaveAccountLabel: UILabel!
    var registerButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(red: 0.08, green: 0.15, blue: 0.25, alpha: 1.0)
        
        setupScrollView()
        setupLogoImageView()
        setupAppNameLabel()
        setupEmailTextField()
        setupPasswordTextField()
        setupSignInButton()
        setupForgotPasswordButton()
        setupDontHaveAccountLabel()
        setupRegisterButton()
        
        initConstraints()
    }
    
    func setupScrollView() {
        scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.backgroundColor = .clear
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(scrollView)
        
        contentView = UIView()
        contentView.backgroundColor = .clear
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
    }
    
    func setupLogoImageView() {
        logoImageView = UIImageView()
        logoImageView.contentMode = .scaleAspectFit
        let config = UIImage.SymbolConfiguration(pointSize: 80, weight: .medium)
        logoImageView.image = UIImage(systemName: "arrow.up.heart.fill", withConfiguration: config)
        logoImageView.tintColor = UIColor(red: 0.33, green: 0.67, blue: 0.93, alpha: 1.0)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(logoImageView)
    }
    
    func setupAppNameLabel() {
        appNameLabel = UILabel()
        appNameLabel.text = "FITQUEST"
        appNameLabel.font = .systemFont(ofSize: 36, weight: .bold)
        appNameLabel.textColor = .white
        appNameLabel.textAlignment = .center
        appNameLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(appNameLabel)
    }
    
    func setupEmailTextField() {
        emailTextField = UITextField()
        emailTextField.placeholder = "Email"
        emailTextField.keyboardType = .emailAddress
        emailTextField.autocapitalizationType = .none
        emailTextField.autocorrectionType = .no
        emailTextField.textColor = .white
        emailTextField.font = .systemFont(ofSize: 16)
        
        emailTextField.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        emailTextField.layer.borderWidth = 1
        emailTextField.layer.borderColor = UIColor(red: 0.33, green: 0.67, blue: 0.93, alpha: 0.5).cgColor
        emailTextField.layer.cornerRadius = 25

        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
        emailTextField.leftView = paddingView
        emailTextField.leftViewMode = .always
        
        emailTextField.attributedPlaceholder = NSAttributedString(
            string: "Email",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        )
        
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(emailTextField)
    }
    
    func setupPasswordTextField() {
        passwordTextField = UITextField()
        passwordTextField.placeholder = "Password"
        passwordTextField.isSecureTextEntry = true
        passwordTextField.textContentType = .password
        passwordTextField.autocapitalizationType = .none
        passwordTextField.autocorrectionType = .no
        passwordTextField.textColor = .white
        passwordTextField.font = .systemFont(ofSize: 16)
        passwordTextField.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        passwordTextField.layer.borderWidth = 1
        passwordTextField.layer.borderColor = UIColor(red: 0.33, green: 0.67, blue: 0.93, alpha: 0.5).cgColor
        passwordTextField.layer.cornerRadius = 25
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
        passwordTextField.leftView = paddingView
        passwordTextField.leftViewMode = .always
        
        passwordTextField.attributedPlaceholder = NSAttributedString(
            string: "Password",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        )
        
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(passwordTextField)
    }
    
    func setupSignInButton() {
        signInButton = UIButton(type: .system)
        signInButton.setTitle("Sign In", for: .normal)
        signInButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
        signInButton.setTitleColor(.white, for: .normal)
        signInButton.backgroundColor = UIColor(red: 0.33, green: 0.67, blue: 0.93, alpha: 1.0)
        signInButton.layer.cornerRadius = 25
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(signInButton)
    }
    
    func setupForgotPasswordButton() {
        forgotPasswordButton = UIButton(type: .system)
        forgotPasswordButton.setTitle("Forgot password?", for: .normal)
        forgotPasswordButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
        forgotPasswordButton.setTitleColor(UIColor(red: 0.33, green: 0.67, blue: 0.93, alpha: 1.0), for: .normal)
        forgotPasswordButton.backgroundColor = .clear
        forgotPasswordButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(forgotPasswordButton)
    }
    
    func setupDontHaveAccountLabel() {
        dontHaveAccountLabel = UILabel()
        dontHaveAccountLabel.text = "Don't have an account?"
        dontHaveAccountLabel.font = .systemFont(ofSize: 16, weight: .regular)
        dontHaveAccountLabel.textColor = .lightGray
        dontHaveAccountLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(dontHaveAccountLabel)
    }
    
    func setupRegisterButton() {
        registerButton = UIButton(type: .system)
        registerButton.setTitle("Register", for: .normal)
        registerButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        registerButton.setTitleColor(UIColor(red: 0.33, green: 0.67, blue: 0.93, alpha: 1.0), for: .normal)
        registerButton.backgroundColor = .clear
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(registerButton)
    }
    
    func initConstraints() {
        NSLayoutConstraint.activate([
            // Scroll View
            scrollView.topAnchor.constraint(equalTo: self.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            // Content View
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // Logo
            logoImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            logoImageView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 60),
            logoImageView.widthAnchor.constraint(equalToConstant: 100),
            logoImageView.heightAnchor.constraint(equalToConstant: 100),
            
            // App Name
            appNameLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 15),
            appNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40),
            appNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),
            
            // Email
            emailTextField.topAnchor.constraint(equalTo: appNameLabel.bottomAnchor, constant: 60),
            emailTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 50),
            emailTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -50),
            emailTextField.heightAnchor.constraint(equalToConstant: 50),
            
            // Password
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20),
            passwordTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 50),
            passwordTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -50),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),
            
            // Sign In Button
            signInButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 35),
            signInButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 50),
            signInButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -50),
            signInButton.heightAnchor.constraint(equalToConstant: 50),
            
            // Forgot Password
            forgotPasswordButton.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 20),
            forgotPasswordButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            forgotPasswordButton.heightAnchor.constraint(equalToConstant: 30),
            
            // Register Section
            dontHaveAccountLabel.topAnchor.constraint(equalTo: forgotPasswordButton.bottomAnchor, constant: 40),
            dontHaveAccountLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: -40),
            
            registerButton.centerYAnchor.constraint(equalTo: dontHaveAccountLabel.centerYAnchor),
            registerButton.leadingAnchor.constraint(equalTo: dontHaveAccountLabel.trailingAnchor, constant: 5),
            
            // Bottom padding
            registerButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
