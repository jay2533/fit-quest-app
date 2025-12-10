//
//  ForgotPasswordView.swift
//  FitQuest
//
//  Created by Sunny Yadav on 12/2/25.
//

import UIKit

class ForgotPasswordView: UIView {
    
    var scrollView: UIScrollView!
    var contentView: UIView!
    
    var logoImageView: UIImageView!
    var titleLabel: UILabel!
    var subtitleLabel: UILabel!
    var emailTextField: UITextField!
    var sendOTPButton: UIButton!
    var backToLoginButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(red: 0.08, green: 0.15, blue: 0.25, alpha: 1.0)
        
        setupScrollView()
        setupLogoImageView()
        setupTitleLabel()
        setupSubtitleLabel()
        setupEmailTextField()
        setupSendOTPButton()
        setupBackToLoginButton()
        
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
        let config = UIImage.SymbolConfiguration(pointSize: 70, weight: .medium)
        logoImageView.image = UIImage(systemName: "lock.rotation", withConfiguration: config)
        logoImageView.tintColor = UIColor(red: 0.33, green: 0.67, blue: 0.93, alpha: 1.0)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(logoImageView)
    }
    
    func setupTitleLabel() {
        titleLabel = UILabel()
        titleLabel.text = "Forgot Password?"
        titleLabel.font = .systemFont(ofSize: 28, weight: .bold)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
    }
    
    func setupSubtitleLabel() {
        subtitleLabel = UILabel()
        subtitleLabel.text = "Enter your email address and we'll send you a link to reset your password."
        subtitleLabel.font = .systemFont(ofSize: 15, weight: .regular)
        subtitleLabel.textColor = .lightGray
        subtitleLabel.textAlignment = .center
        subtitleLabel.numberOfLines = 0
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(subtitleLabel)
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
    
    func setupSendOTPButton() {
        sendOTPButton = UIButton(type: .system)
        sendOTPButton.setTitle("Send Reset Link", for: .normal)
        sendOTPButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
        sendOTPButton.setTitleColor(.white, for: .normal)
        sendOTPButton.backgroundColor = UIColor(red: 0.33, green: 0.67, blue: 0.93, alpha: 1.0)
        sendOTPButton.layer.cornerRadius = 25
        sendOTPButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(sendOTPButton)
    }
    
    func setupBackToLoginButton() {
        backToLoginButton = UIButton(type: .system)
        backToLoginButton.setTitle("Back to Login", for: .normal)
        backToLoginButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        backToLoginButton.setTitleColor(UIColor(red: 0.33, green: 0.67, blue: 0.93, alpha: 1.0), for: .normal)
        backToLoginButton.backgroundColor = .clear
        backToLoginButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(backToLoginButton)
    }
    
    func initConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            logoImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            logoImageView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 80),
            logoImageView.widthAnchor.constraint(equalToConstant: 90),
            logoImageView.heightAnchor.constraint(equalToConstant: 90),
            
            titleLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
            subtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),
            
            emailTextField.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 40),
            emailTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 50),
            emailTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -50),
            emailTextField.heightAnchor.constraint(equalToConstant: 50),
            
            sendOTPButton.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 30),
            sendOTPButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 50),
            sendOTPButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -50),
            sendOTPButton.heightAnchor.constraint(equalToConstant: 50),
            
            backToLoginButton.topAnchor.constraint(equalTo: sendOTPButton.bottomAnchor, constant: 20),
            backToLoginButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            backToLoginButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -60)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
