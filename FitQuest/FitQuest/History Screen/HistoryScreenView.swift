//
//  HistoryScreenView.swift
//  FitQuest
//
//  Created by Student on 11/18/25.
//

import UIKit

class HistoryScreenView: UIView {

    // MARK: - Header Components
    var logoImageView: UIImageView!
    var titleLabel: UILabel!
    var profileButton: UIButton!
    
    // MARK: - Category List
    var categoryTableView: UITableView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(red: 0.08, green: 0.15, blue: 0.25, alpha: 1.0)
        
        setupHeader()
        setupCategoryTableView()
        
        initConstraints()
    }
    
    // MARK: - Setup Methods
        
    func setupHeader() {
        // Logo (will act as back button)
        logoImageView = UIImageView()
        logoImageView.contentMode = .scaleAspectFit
        let config = UIImage.SymbolConfiguration(pointSize: 30, weight: .medium)
        logoImageView.image = UIImage(systemName: "arrow.up.heart.fill", withConfiguration: config)
        logoImageView.tintColor = UIColor(red: 0.33, green: 0.67, blue: 0.93, alpha: 1.0)
        logoImageView.isUserInteractionEnabled = true  // Enable tap
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(logoImageView)
        
        // Title
        titleLabel = UILabel()
        titleLabel.text = "Task History"
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(titleLabel)
        
        // Profile Button
        profileButton = UIButton(type: .system)
        let profileConfig = UIImage.SymbolConfiguration(pointSize: 28, weight: .medium)
        profileButton.setImage(UIImage(systemName: "person.circle.fill", withConfiguration: profileConfig), for: .normal)
        profileButton.tintColor = UIColor(red: 0.33, green: 0.67, blue: 0.93, alpha: 1.0)
        profileButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(profileButton)
    }
    
    func setupCategoryTableView() {
        categoryTableView = UITableView()
        categoryTableView.backgroundColor = .clear
        categoryTableView.separatorStyle = .none
        categoryTableView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(categoryTableView)
        
        // Register cell
        categoryTableView.register(HistoryTableViewCell.self, forCellReuseIdentifier: HistoryTableViewCell.identifier)
    }
    
    func initConstraints() {
        NSLayoutConstraint.activate([
            // Logo (top left)
            logoImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            logoImageView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 10),
            logoImageView.widthAnchor.constraint(equalToConstant: 35),
            logoImageView.heightAnchor.constraint(equalToConstant: 35),
            
            // Title (center)
            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: logoImageView.centerYAnchor),
            
            // Profile Button (top right)
            profileButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            profileButton.centerYAnchor.constraint(equalTo: logoImageView.centerYAnchor),
            profileButton.widthAnchor.constraint(equalToConstant: 35),
            profileButton.heightAnchor.constraint(equalToConstant: 35),
            
            // Category Table View
            categoryTableView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 30),
            categoryTableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            categoryTableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            categoryTableView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
