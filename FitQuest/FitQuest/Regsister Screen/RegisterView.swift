//
//  RegisterView.swift
//  FitQuest
//
//  Created by Sunny Yadav on 11/17/25.
//

import UIKit

class RegisterView: UIView {
    var scrollView: UIScrollView!
    var contentView: UIView!
    var logoImageView: UIImageView!
    var appNameLabel: UILabel!
    var signUpTitleLabel: UILabel!
    var profileImageButton: UIButton!
    var nameTextField: UITextField!
    var emailTextField: UITextField!
    var passwordTextField: UITextField!
    var dateOfBirthTextField: UITextField!
    var signUpButton: UIButton!
    var haveAccountLabel: UILabel!
    var signInButton: UIButton!
    var datePicker: UIDatePicker!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(red: 0.08, green: 0.15, blue: 0.25, alpha: 1.0)
        
        setupScrollView()
        setupLogoImageView()
        setupAppNameLabel()
        setupSignUpTitleLabel()
        setupProfileImageButton()
        setupNameTextField()
        setupEmailTextField()
        setupPasswordTextField()
        setupDateOfBirthTextField()
        setupSignUpButton()
        setupHaveAccountLabel()
        setupSignInButton()
        setupDatePicker()
        
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
        logoImageView.image = UIImage(named: "fitquest_logo")?.withRenderingMode(.alwaysOriginal)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(logoImageView)
    }
    
    func setupAppNameLabel() {
        appNameLabel = UILabel()
        appNameLabel.text = "FITQUEST"
        appNameLabel.font = .systemFont(ofSize: 32, weight: .bold)
        appNameLabel.textColor = .white
        appNameLabel.textAlignment = .center
        appNameLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(appNameLabel)
    }
    
    func setupSignUpTitleLabel() {
        signUpTitleLabel = UILabel()
        signUpTitleLabel.text = "Sign Up"
        signUpTitleLabel.font = .systemFont(ofSize: 28, weight: .semibold)
        signUpTitleLabel.textColor = .white
        signUpTitleLabel.textAlignment = .center
        signUpTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(signUpTitleLabel)
    }
    
    func setupProfileImageButton() {
        profileImageButton = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 50, weight: .regular)
        let profileImage = UIImage(systemName: "person.circle.fill", withConfiguration: config)
        profileImageButton.setImage(profileImage, for: .normal)
        profileImageButton.tintColor = UIColor(red: 0.33, green: 0.67, blue: 0.93, alpha: 1.0)
        
        profileImageButton.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        profileImageButton.layer.cornerRadius = 60
        profileImageButton.layer.borderWidth = 2
        profileImageButton.layer.borderColor = UIColor(red: 0.33, green: 0.67, blue: 0.93, alpha: 0.5).cgColor
        profileImageButton.clipsToBounds = true
        profileImageButton.imageView?.contentMode = .scaleAspectFill
        
        profileImageButton.showsMenuAsPrimaryAction = true
        
        profileImageButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(profileImageButton)
    }
    
    func setupNameTextField() {
        nameTextField = createTextField(placeholder: "Name")
        nameTextField.textContentType = .name
        contentView.addSubview(nameTextField)
    }
    
    func setupEmailTextField() {
        emailTextField = createTextField(placeholder: "Email")
        emailTextField.keyboardType = .emailAddress
        emailTextField.textContentType = .emailAddress
        emailTextField.autocapitalizationType = .none
        contentView.addSubview(emailTextField)
    }
    
    func setupPasswordTextField() {
        passwordTextField = createTextField(placeholder: "Password")
        passwordTextField.isSecureTextEntry = true
        passwordTextField.textContentType = .newPassword
        contentView.addSubview(passwordTextField)
    }
    
    func setupDateOfBirthTextField() {
        dateOfBirthTextField = createTextField(placeholder: "Date of birth")
        dateOfBirthTextField.inputView = datePicker
        contentView.addSubview(dateOfBirthTextField)
    }
    
    func setupDatePicker() {
        datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.maximumDate = Date()
        
        var dateComponents = DateComponents()
        dateComponents.year = -100
        let minDate = Calendar.current.date(byAdding: dateComponents, to: Date())
        datePicker.minimumDate = minDate
        
        dateComponents.year = -13
        let maxDate = Calendar.current.date(byAdding: dateComponents, to: Date())
        datePicker.maximumDate = maxDate
        
        dateOfBirthTextField.inputView = datePicker
    }
    
    func setupSignUpButton() {
        signUpButton = UIButton(type: .system)
        signUpButton.setTitle("Sign Up", for: .normal)
        signUpButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
        signUpButton.setTitleColor(.white, for: .normal)
        signUpButton.backgroundColor = UIColor(red: 0.33, green: 0.67, blue: 0.93, alpha: 1.0)
        signUpButton.layer.cornerRadius = 25
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(signUpButton)
    }
    
    func setupHaveAccountLabel() {
        haveAccountLabel = UILabel()
        haveAccountLabel.text = "Have an account?"
        haveAccountLabel.font = .systemFont(ofSize: 16, weight: .regular)
        haveAccountLabel.textColor = .lightGray
        haveAccountLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(haveAccountLabel)
    }
    
    func setupSignInButton() {
        signInButton = UIButton(type: .system)
        signInButton.setTitle("Sign In", for: .normal)
        signInButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        signInButton.setTitleColor(UIColor(red: 0.33, green: 0.67, blue: 0.93, alpha: 1.0), for: .normal)
        signInButton.backgroundColor = .clear
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(signInButton)
    }
    
    private func createTextField(placeholder: String) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.autocorrectionType = .no
        textField.textColor = .white
        textField.font = .systemFont(ofSize: 16)
        
        textField.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor(red: 0.33, green: 0.67, blue: 0.93, alpha: 0.5).cgColor
        textField.layer.cornerRadius = 25
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        
        textField.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        )
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }
    
    func initConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            logoImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            logoImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 40),
            logoImageView.widthAnchor.constraint(equalToConstant: 80),
            logoImageView.heightAnchor.constraint(equalToConstant: 80),
            
            appNameLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 10),
            appNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40),
            appNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),
            
            signUpTitleLabel.topAnchor.constraint(equalTo: appNameLabel.bottomAnchor, constant: 20),
            signUpTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40),
            signUpTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),
            
            profileImageButton.topAnchor.constraint(equalTo: signUpTitleLabel.bottomAnchor, constant: 25),
            profileImageButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            profileImageButton.widthAnchor.constraint(equalToConstant: 120),
            profileImageButton.heightAnchor.constraint(equalToConstant: 120),
            
            nameTextField.topAnchor.constraint(equalTo: profileImageButton.bottomAnchor, constant: 25),
            nameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 50),
            nameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -50),
            nameTextField.heightAnchor.constraint(equalToConstant: 50),
            
            emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 15),
            emailTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 50),
            emailTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -50),
            emailTextField.heightAnchor.constraint(equalToConstant: 50),
            
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 15),
            passwordTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 50),
            passwordTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -50),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),
            
            dateOfBirthTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 15),
            dateOfBirthTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 50),
            dateOfBirthTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -50),
            dateOfBirthTextField.heightAnchor.constraint(equalToConstant: 50),
            
            signUpButton.topAnchor.constraint(equalTo: dateOfBirthTextField.bottomAnchor, constant: 35),
            signUpButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 50),
            signUpButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -50),
            signUpButton.heightAnchor.constraint(equalToConstant: 50),
            
            haveAccountLabel.topAnchor.constraint(equalTo: signUpButton.bottomAnchor, constant: 25),
            haveAccountLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: -30),
            
            signInButton.centerYAnchor.constraint(equalTo: haveAccountLabel.centerYAnchor),
            signInButton.leadingAnchor.constraint(equalTo: haveAccountLabel.trailingAnchor, constant: 5),
            
            signInButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
