//
//  LoginView.swift
//  FitQuest
//
//  Created by Sunny Yadav on 11/17/25.
//

import UIKit

class LoginView: UIView {
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
    
    func setupLogoImageView() {
        logoImageView = UIImageView()
        logoImageView.contentMode = .scaleAspectFit
        // Using SF Symbol as placeholder
        let config = UIImage.SymbolConfiguration(pointSize: 80, weight: .medium)
        logoImageView.image = UIImage(systemName: "arrow.up.heart.fill", withConfiguration: config)
        logoImageView.tintColor = UIColor(red: 0.33, green: 0.67, blue: 0.93, alpha: 1.0)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(logoImageView)
    }
    
    func setupAppNameLabel() {
        appNameLabel = UILabel()
        appNameLabel.text = "FITQUEST"
        appNameLabel.font = .systemFont(ofSize: 36, weight: .bold)
        appNameLabel.textColor = .white
        appNameLabel.textAlignment = .center
        appNameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(appNameLabel)
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
        self.addSubview(emailTextField)
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
        self.addSubview(passwordTextField)
    }
    
    func setupSignInButton() {
        signInButton = UIButton(type: .system)
        signInButton.setTitle("Sign In", for: .normal)
        signInButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
        signInButton.setTitleColor(.white, for: .normal)
        signInButton.backgroundColor = UIColor(red: 0.33, green: 0.67, blue: 0.93, alpha: 1.0)
        signInButton.layer.cornerRadius = 25
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(signInButton)
    }
    
    func setupForgotPasswordButton() {
        forgotPasswordButton = UIButton(type: .system)
        forgotPasswordButton.setTitle("Forgot password?", for: .normal)
        forgotPasswordButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
        forgotPasswordButton.setTitleColor(UIColor(red: 0.33, green: 0.67, blue: 0.93, alpha: 1.0), for: .normal)
        forgotPasswordButton.backgroundColor = .clear
        forgotPasswordButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(forgotPasswordButton)
    }
    
    func setupDontHaveAccountLabel() {
        dontHaveAccountLabel = UILabel()
        dontHaveAccountLabel.text = "Don't have an account?"
        dontHaveAccountLabel.font = .systemFont(ofSize: 16, weight: .regular)
        dontHaveAccountLabel.textColor = .lightGray
        dontHaveAccountLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(dontHaveAccountLabel)
    }
    
    func setupRegisterButton() {
        registerButton = UIButton(type: .system)
        registerButton.setTitle("Register", for: .normal)
        registerButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        registerButton.setTitleColor(UIColor(red: 0.33, green: 0.67, blue: 0.93, alpha: 1.0), for: .normal)
        registerButton.backgroundColor = .clear
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(registerButton)
    }
    
    func initConstraints() {
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            logoImageView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 80),
            logoImageView.widthAnchor.constraint(equalToConstant: 100),
            logoImageView.heightAnchor.constraint(equalToConstant: 100),
            
            appNameLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 15),
            appNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 40),
            appNameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -40),
            
            emailTextField.topAnchor.constraint(equalTo: appNameLabel.bottomAnchor, constant: 60),
            emailTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 50),
            emailTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -50),
            emailTextField.heightAnchor.constraint(equalToConstant: 50),
            
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20),
            passwordTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 50),
            passwordTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -50),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),
            
            signInButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 35),
            signInButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 50),
            signInButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -50),
            signInButton.heightAnchor.constraint(equalToConstant: 50),
            
            forgotPasswordButton.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 20),
            forgotPasswordButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            forgotPasswordButton.heightAnchor.constraint(equalToConstant: 30),
            
            dontHaveAccountLabel.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            dontHaveAccountLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: -40),
            
            registerButton.centerYAnchor.constraint(equalTo: dontHaveAccountLabel.centerYAnchor),
            registerButton.leadingAnchor.constraint(equalTo: dontHaveAccountLabel.trailingAnchor, constant: 5)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
