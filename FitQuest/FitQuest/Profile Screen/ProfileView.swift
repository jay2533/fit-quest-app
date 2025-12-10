//
//  ProfileView.swift
//  FitQuest
//
//  Created by Sunny Yadav on 12/4/25.
//

import UIKit

class ProfileView: UIView {
    
    var scrollView: UIScrollView!
    var contentView: UIView!
    var backButton: UIButton!
    var titleLabel: UILabel!
    var imagesContainer: UIView!
    var userImageView: UIImageView!
    var aiAvatarImageView: UIImageView!
    var userImageLabel: UILabel!
    var detailsContainer: UIView!
    var nameContainer: UIView!
    var nameLabel: UILabel!
    var nameValueLabel: UILabel!
    var nameEditButton: UIButton!
    var emailContainer: UIView!
    var emailLabel: UILabel!
    var emailValueLabel: UILabel!
    var dobContainer: UIView!
    var dobLabel: UILabel!
    var dobValueLabel: UILabel!
    var dobEditButton: UIButton!
    var statsContainer: UIView!
    var xpLabel: UILabel!
    var xpValueLabel: UILabel!
    var levelLabel: UILabel!
    var levelValueLabel: UILabel!
    var tierLabel: UILabel!
    var tierValueLabel: UILabel!
    var logoutButton: UIButton!
    var deleteAccountButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(red: 0.08, green: 0.15, blue: 0.25, alpha: 1.0)
        
        setupScrollView()
        setupHeader()
        setupProfileImages()
        setupDetailsContainer()
        setupActionButtons()
        
        initConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
    func setupHeader() {
        backButton = UIButton(type: .system)
        let backConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold)
        backButton.setImage(UIImage(systemName: "chevron.left", withConfiguration: backConfig), for: .normal)
        backButton.tintColor = .white
        backButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(backButton)
        
        titleLabel = UILabel()
        titleLabel.text = "Profile"
        titleLabel.font = .systemFont(ofSize: 28, weight: .bold)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
    }
    
    func setupProfileImages() {
        imagesContainer = UIView()
        imagesContainer.backgroundColor = UIColor.white.withAlphaComponent(0.05)
        imagesContainer.layer.cornerRadius = 20
        imagesContainer.layer.borderWidth = 1
        imagesContainer.layer.borderColor = UIColor(red: 0.16, green: 0.34, blue: 0.57, alpha: 0.7).cgColor
        imagesContainer.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imagesContainer)
        
        userImageView = UIImageView()
        userImageView.contentMode = .scaleAspectFill
        userImageView.clipsToBounds = true
        userImageView.layer.cornerRadius = 60
        userImageView.layer.borderWidth = 3
        userImageView.layer.borderColor = UIColor(red: 0.33, green: 0.67, blue: 0.93, alpha: 1.0).cgColor
        userImageView.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        let profileConfig = UIImage.SymbolConfiguration(pointSize: 50, weight: .regular)
        userImageView.image = UIImage(systemName: "person.circle.fill", withConfiguration: profileConfig)
        userImageView.tintColor = .lightGray
        userImageView.translatesAutoresizingMaskIntoConstraints = false
        imagesContainer.addSubview(userImageView)
        
        aiAvatarImageView = UIImageView()
        aiAvatarImageView.contentMode = .scaleAspectFill
        aiAvatarImageView.clipsToBounds = true
        aiAvatarImageView.layer.cornerRadius = 60
        aiAvatarImageView.layer.borderWidth = 3
        aiAvatarImageView.layer.borderColor = UIColor(red: 0.55, green: 0.27, blue: 0.87, alpha: 1.0).cgColor
        aiAvatarImageView.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        let aiConfig = UIImage.SymbolConfiguration(pointSize: 50, weight: .regular)
        aiAvatarImageView.image = UIImage(systemName: "sparkles", withConfiguration: aiConfig)
        aiAvatarImageView.tintColor = UIColor(red: 0.55, green: 0.27, blue: 0.87, alpha: 1.0)
        aiAvatarImageView.translatesAutoresizingMaskIntoConstraints = false
        imagesContainer.addSubview(aiAvatarImageView)
        
        userImageLabel = UILabel()
        userImageLabel.text = "Your character"
        userImageLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        userImageLabel.textColor = .white
        userImageLabel.textAlignment = .center
        userImageLabel.translatesAutoresizingMaskIntoConstraints = false
        imagesContainer.addSubview(userImageLabel)
    }
    
    func setupDetailsContainer() {
        detailsContainer = UIView()
        detailsContainer.backgroundColor = UIColor.white.withAlphaComponent(0.05)
        detailsContainer.layer.cornerRadius = 20
        detailsContainer.layer.borderWidth = 1
        detailsContainer.layer.borderColor = UIColor(red: 0.16, green: 0.34, blue: 0.57, alpha: 0.7).cgColor
        detailsContainer.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(detailsContainer)
        
        nameContainer = createDetailRow()
        detailsContainer.addSubview(nameContainer)
        
        nameLabel = createFieldLabel(text: "Name")
        nameContainer.addSubview(nameLabel)
        
        nameValueLabel = createValueLabel(text: "Loading...")
        nameContainer.addSubview(nameValueLabel)
        
        nameEditButton = createEditButton()
        nameContainer.addSubview(nameEditButton)
        
        emailContainer = createDetailRow()
        detailsContainer.addSubview(emailContainer)
        
        emailLabel = createFieldLabel(text: "Email")
        emailContainer.addSubview(emailLabel)
        
        emailValueLabel = createValueLabel(text: "Loading...")
        emailContainer.addSubview(emailValueLabel)
        
        dobContainer = createDetailRow()
        detailsContainer.addSubview(dobContainer)
        
        dobLabel = createFieldLabel(text: "Date of Birth")
        dobContainer.addSubview(dobLabel)
        
        dobValueLabel = createValueLabel(text: "Loading...")
        dobContainer.addSubview(dobValueLabel)
        
        dobEditButton = createEditButton()
        dobContainer.addSubview(dobEditButton)
        
        statsContainer = UIView()
        statsContainer.backgroundColor = UIColor.white.withAlphaComponent(0.08)
        statsContainer.layer.cornerRadius = 12
        statsContainer.translatesAutoresizingMaskIntoConstraints = false
        detailsContainer.addSubview(statsContainer)
        
        xpLabel = createFieldLabel(text: "Total XP")
        statsContainer.addSubview(xpLabel)
        
        xpValueLabel = createValueLabel(text: "0")
        xpValueLabel.textColor = UIColor(red: 0.33, green: 0.67, blue: 0.93, alpha: 1.0)
        xpValueLabel.font = .systemFont(ofSize: 20, weight: .bold)
        statsContainer.addSubview(xpValueLabel)
        
        levelLabel = createFieldLabel(text: "Level")
        statsContainer.addSubview(levelLabel)
        
        levelValueLabel = createValueLabel(text: "1")
        levelValueLabel.textColor = UIColor(red: 0.33, green: 0.67, blue: 0.93, alpha: 1.0)
        levelValueLabel.font = .systemFont(ofSize: 20, weight: .bold)
        statsContainer.addSubview(levelValueLabel)
        
        tierLabel = createFieldLabel(text: "Tier")
        statsContainer.addSubview(tierLabel)
        
        tierValueLabel = createValueLabel(text: "I")
        tierValueLabel.textColor = UIColor(red: 0.33, green: 0.67, blue: 0.93, alpha: 1.0)
        tierValueLabel.font = .systemFont(ofSize: 20, weight: .bold)
        statsContainer.addSubview(tierValueLabel)
    }
    
    func setupActionButtons() {
        logoutButton = UIButton(type: .system)
        logoutButton.setTitle("Logout", for: .normal)
        logoutButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        logoutButton.setTitleColor(.white, for: .normal)
        logoutButton.backgroundColor = UIColor(red: 0.33, green: 0.67, blue: 0.93, alpha: 1.0)
        logoutButton.layer.cornerRadius = 25
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(logoutButton)
        
        deleteAccountButton = UIButton(type: .system)
        deleteAccountButton.setTitle("Delete Account", for: .normal)
        deleteAccountButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        deleteAccountButton.setTitleColor(.white, for: .normal)
        deleteAccountButton.backgroundColor = UIColor.systemRed.withAlphaComponent(0.8)
        deleteAccountButton.layer.cornerRadius = 25
        deleteAccountButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(deleteAccountButton)
    }
        
    func createDetailRow() -> UIView {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    func createFieldLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    func createValueLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    func createEditButton() -> UIButton {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 16, weight: .medium)
        button.setImage(UIImage(systemName: "pencil.circle.fill", withConfiguration: config), for: .normal)
        button.tintColor = UIColor(red: 0.33, green: 0.67, blue: 0.93, alpha: 1.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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
            
            backButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            backButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            backButton.widthAnchor.constraint(equalToConstant: 40),
            backButton.heightAnchor.constraint(equalToConstant: 40),
            
            titleLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            imagesContainer.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            imagesContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            imagesContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            imagesContainer.heightAnchor.constraint(equalToConstant: 180),

            userImageView.topAnchor.constraint(equalTo: imagesContainer.topAnchor, constant: 20),
            userImageView.trailingAnchor.constraint(equalTo: imagesContainer.centerXAnchor, constant: -12),
            userImageView.widthAnchor.constraint(equalToConstant: 120),
            userImageView.heightAnchor.constraint(equalToConstant: 120),
            
            aiAvatarImageView.topAnchor.constraint(equalTo: imagesContainer.topAnchor, constant: 20),
            aiAvatarImageView.leadingAnchor.constraint(equalTo: imagesContainer.centerXAnchor, constant: 12),
            aiAvatarImageView.widthAnchor.constraint(equalToConstant: 120),
            aiAvatarImageView.heightAnchor.constraint(equalToConstant: 120),
            
            userImageLabel.topAnchor.constraint(equalTo: userImageView.bottomAnchor, constant: 12),
            userImageLabel.centerXAnchor.constraint(equalTo: imagesContainer.centerXAnchor),
            userImageLabel.bottomAnchor.constraint(equalTo: imagesContainer.bottomAnchor, constant: -12),
            
            detailsContainer.topAnchor.constraint(equalTo: imagesContainer.bottomAnchor, constant: 24),
            detailsContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            detailsContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            nameContainer.topAnchor.constraint(equalTo: detailsContainer.topAnchor, constant: 20),
            nameContainer.leadingAnchor.constraint(equalTo: detailsContainer.leadingAnchor, constant: 16),
            nameContainer.trailingAnchor.constraint(equalTo: detailsContainer.trailingAnchor, constant: -16),
            nameContainer.heightAnchor.constraint(equalToConstant: 60),
            
            nameLabel.topAnchor.constraint(equalTo: nameContainer.topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: nameContainer.leadingAnchor),
            
            nameValueLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            nameValueLabel.leadingAnchor.constraint(equalTo: nameContainer.leadingAnchor),
            
            nameEditButton.centerYAnchor.constraint(equalTo: nameValueLabel.centerYAnchor),
            nameEditButton.leadingAnchor.constraint(equalTo: nameValueLabel.trailingAnchor, constant: 8),
            nameEditButton.widthAnchor.constraint(equalToConstant: 24),
            nameEditButton.heightAnchor.constraint(equalToConstant: 24),
            
            emailContainer.topAnchor.constraint(equalTo: nameContainer.bottomAnchor, constant: 8),
            emailContainer.leadingAnchor.constraint(equalTo: detailsContainer.leadingAnchor, constant: 16),
            emailContainer.trailingAnchor.constraint(equalTo: detailsContainer.trailingAnchor, constant: -16),
            emailContainer.heightAnchor.constraint(equalToConstant: 60),
            
            emailLabel.topAnchor.constraint(equalTo: emailContainer.topAnchor),
            emailLabel.leadingAnchor.constraint(equalTo: emailContainer.leadingAnchor),
            
            emailValueLabel.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 4),
            emailValueLabel.leadingAnchor.constraint(equalTo: emailContainer.leadingAnchor),
            emailValueLabel.trailingAnchor.constraint(equalTo: emailContainer.trailingAnchor, constant: -8),
            
            dobContainer.topAnchor.constraint(equalTo: emailContainer.bottomAnchor, constant: 8),
            dobContainer.leadingAnchor.constraint(equalTo: detailsContainer.leadingAnchor, constant: 16),
            dobContainer.trailingAnchor.constraint(equalTo: detailsContainer.trailingAnchor, constant: -16),
            dobContainer.heightAnchor.constraint(equalToConstant: 60),
            
            dobLabel.topAnchor.constraint(equalTo: dobContainer.topAnchor),
            dobLabel.leadingAnchor.constraint(equalTo: dobContainer.leadingAnchor),
            
            dobValueLabel.topAnchor.constraint(equalTo: dobLabel.bottomAnchor, constant: 4),
            dobValueLabel.leadingAnchor.constraint(equalTo: dobContainer.leadingAnchor),
            
            dobEditButton.centerYAnchor.constraint(equalTo: dobValueLabel.centerYAnchor),
            dobEditButton.leadingAnchor.constraint(equalTo: dobValueLabel.trailingAnchor, constant: 8),
            dobEditButton.widthAnchor.constraint(equalToConstant: 24),
            dobEditButton.heightAnchor.constraint(equalToConstant: 24),
            
            statsContainer.topAnchor.constraint(equalTo: dobContainer.bottomAnchor, constant: 20),
            statsContainer.leadingAnchor.constraint(equalTo: detailsContainer.leadingAnchor, constant: 16),
            statsContainer.trailingAnchor.constraint(equalTo: detailsContainer.trailingAnchor, constant: -16),
            statsContainer.heightAnchor.constraint(equalToConstant: 100),
            statsContainer.bottomAnchor.constraint(equalTo: detailsContainer.bottomAnchor, constant: -20),
            
            xpLabel.topAnchor.constraint(equalTo: statsContainer.topAnchor, constant: 16),
            xpLabel.leadingAnchor.constraint(equalTo: statsContainer.leadingAnchor, constant: 20),
            
            xpValueLabel.topAnchor.constraint(equalTo: xpLabel.bottomAnchor, constant: 4),
            xpValueLabel.centerXAnchor.constraint(equalTo: xpLabel.centerXAnchor),
            
            levelLabel.topAnchor.constraint(equalTo: statsContainer.topAnchor, constant: 16),
            levelLabel.centerXAnchor.constraint(equalTo: statsContainer.centerXAnchor),
            
            levelValueLabel.topAnchor.constraint(equalTo: levelLabel.bottomAnchor, constant: 4),
            levelValueLabel.centerXAnchor.constraint(equalTo: levelLabel.centerXAnchor),
            
            tierLabel.topAnchor.constraint(equalTo: statsContainer.topAnchor, constant: 16),
            tierLabel.trailingAnchor.constraint(equalTo: statsContainer.trailingAnchor, constant: -20),
            
            tierValueLabel.topAnchor.constraint(equalTo: tierLabel.bottomAnchor, constant: 4),
            tierValueLabel.centerXAnchor.constraint(equalTo: tierLabel.centerXAnchor),
            
            logoutButton.topAnchor.constraint(equalTo: detailsContainer.bottomAnchor, constant: 30),
            logoutButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40),
            logoutButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),
            logoutButton.heightAnchor.constraint(equalToConstant: 50),
            
            deleteAccountButton.topAnchor.constraint(equalTo: logoutButton.bottomAnchor, constant: 16),
            deleteAccountButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40),
            deleteAccountButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),
            deleteAccountButton.heightAnchor.constraint(equalToConstant: 50),
            
            deleteAccountButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40)
        ])
    }
}
