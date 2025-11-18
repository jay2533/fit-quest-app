//
//  LandingView.swift
//  FitQuest
//
//  Created by Sunny Yadav on 11/17/25.
//

import UIKit

class LandingView: UIView {
    var logoImageView: UIImageView!
    var appNameLabel: UILabel!
    var signUpButton: UIButton!
    var logInButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(red: 0.08, green: 0.15, blue: 0.25, alpha: 1.0)
        
        setupLogoImageView()
        setupAppNameLabel()
        setupSignUpButton()
        setupLogInButton()
        
        initConstraints()
    }
    
    func setupLogoImageView() {
        logoImageView = UIImageView()
        logoImageView.contentMode = .scaleAspectFit
        // Using SF Symbol as placeholder
        let config = UIImage.SymbolConfiguration(pointSize: 120, weight: .medium)
        logoImageView.image = UIImage(systemName: "arrow.up.heart.fill", withConfiguration: config)
        logoImageView.tintColor = UIColor(red: 0.33, green: 0.67, blue: 0.93, alpha: 1.0)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(logoImageView)
    }
    
    func setupAppNameLabel() {
        appNameLabel = UILabel()
        appNameLabel.text = "FITQUEST"
        appNameLabel.font = .systemFont(ofSize: 42, weight: .bold)
        appNameLabel.textColor = .white
        appNameLabel.textAlignment = .center
        appNameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(appNameLabel)
    }
    
    func setupSignUpButton() {
        signUpButton = UIButton(type: .system)
        signUpButton.setTitle("Sign Up", for: .normal)
        signUpButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
        signUpButton.setTitleColor(.white, for: .normal)
        signUpButton.backgroundColor = UIColor(red: 0.33, green: 0.67, blue: 0.93, alpha: 1.0)
        signUpButton.layer.cornerRadius = 25
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(signUpButton)
    }
    
    func setupLogInButton() {
        logInButton = UIButton(type: .system)
        logInButton.setTitle("Log In", for: .normal)
        logInButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        logInButton.setTitleColor(UIColor(red: 0.33, green: 0.67, blue: 0.93, alpha: 1.0), for: .normal)
        logInButton.backgroundColor = .clear
        logInButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(logInButton)
    }
    
    func initConstraints() {
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -100),
            logoImageView.widthAnchor.constraint(equalToConstant: 150),
            logoImageView.heightAnchor.constraint(equalToConstant: 150),
            
            appNameLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 20),
            appNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 40),
            appNameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -40),
            
            signUpButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 50),
            signUpButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -50),
            signUpButton.bottomAnchor.constraint(equalTo: logInButton.topAnchor, constant: -20),
            signUpButton.heightAnchor.constraint(equalToConstant: 50),
            
            logInButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            logInButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -60),
            logInButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
