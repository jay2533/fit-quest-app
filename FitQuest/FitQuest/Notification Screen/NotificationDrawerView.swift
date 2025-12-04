//
//  NotificationDrawerView.swift
//  FitQuest
//
//  Created by Sunny Yadav on 12/4/25.
//


//
//  NotificationDrawerView.swift
//  FitQuest
//
//  Created by Sunny Yadav on 12/2/25.
//

import UIKit

class NotificationDrawerView: UIView {
    
    var backgroundOverlay: UIView!
    var drawerContainer: UIView!
    var headerView: UIView!
    var titleLabel: UILabel!
    var closeButton: UIButton!
    var markAllReadButton: UIButton!
    var tableView: UITableView!
    var emptyStateLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDrawer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupDrawer() {
        // Background Overlay (Dark transparent)
        backgroundOverlay = UIView()
        backgroundOverlay.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        backgroundOverlay.alpha = 0
        backgroundOverlay.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(backgroundOverlay)
        
        // Drawer Container (Slides from left)
        drawerContainer = UIView()
        drawerContainer.backgroundColor = UIColor(red: 0.08, green: 0.15, blue: 0.25, alpha: 1.0)
        drawerContainer.layer.cornerRadius = 0
        drawerContainer.layer.shadowColor = UIColor.black.cgColor
        drawerContainer.layer.shadowOpacity = 0.3
        drawerContainer.layer.shadowOffset = CGSize(width: 2, height: 0)
        drawerContainer.layer.shadowRadius = 10
        drawerContainer.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(drawerContainer)
        
        // Header
        headerView = UIView()
        headerView.backgroundColor = UIColor.white.withAlphaComponent(0.05)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        drawerContainer.addSubview(headerView)
        
        titleLabel = UILabel()
        titleLabel.text = "Notifications"
        titleLabel.font = .systemFont(ofSize: 22, weight: .bold)
        titleLabel.textColor = .white
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(titleLabel)
        
        closeButton = UIButton(type: .system)
        let closeConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold)
        closeButton.setImage(UIImage(systemName: "xmark", withConfiguration: closeConfig), for: .normal)
        closeButton.tintColor = .white
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(closeButton)
        
        markAllReadButton = UIButton(type: .system)
        markAllReadButton.setTitle("Mark all read", for: .normal)
        markAllReadButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        markAllReadButton.setTitleColor(UIColor(red: 0.33, green: 0.67, blue: 0.93, alpha: 1.0), for: .normal)
        markAllReadButton.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(markAllReadButton)
        
        // Table View
        tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        drawerContainer.addSubview(tableView)
        
        tableView.register(NotificationCell.self, forCellReuseIdentifier: NotificationCell.identifier)
        
        // Empty State
        emptyStateLabel = UILabel()
        emptyStateLabel.text = "No notifications"
        emptyStateLabel.font = .systemFont(ofSize: 16, weight: .regular)
        emptyStateLabel.textColor = .lightGray
        emptyStateLabel.textAlignment = .center
        emptyStateLabel.isHidden = true
        emptyStateLabel.translatesAutoresizingMaskIntoConstraints = false
        drawerContainer.addSubview(emptyStateLabel)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            // Background Overlay
            backgroundOverlay.topAnchor.constraint(equalTo: self.topAnchor),
            backgroundOverlay.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            backgroundOverlay.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            backgroundOverlay.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            // Drawer Container
            drawerContainer.topAnchor.constraint(equalTo: self.topAnchor),
            drawerContainer.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            drawerContainer.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            drawerContainer.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.85),
            
            // Header
            headerView.topAnchor.constraint(equalTo: drawerContainer.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: drawerContainer.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: drawerContainer.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 80),
            
            titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
            titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            
            closeButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -20),
            closeButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            closeButton.widthAnchor.constraint(equalToConstant: 32),
            closeButton.heightAnchor.constraint(equalToConstant: 32),
            
            markAllReadButton.trailingAnchor.constraint(equalTo: closeButton.leadingAnchor, constant: -12),
            markAllReadButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            
            // Table View
            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: drawerContainer.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: drawerContainer.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: drawerContainer.bottomAnchor),
            
            // Empty State
            emptyStateLabel.centerXAnchor.constraint(equalTo: drawerContainer.centerXAnchor),
            emptyStateLabel.centerYAnchor.constraint(equalTo: drawerContainer.centerYAnchor)
        ])
    }
    
    // MARK: - Show/Hide Drawer
    func showDrawer() {
        // Initially position drawer off-screen to the left
        self.drawerContainer.transform = CGAffineTransform(translationX: -self.bounds.width * 0.85, y: 0)
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
            self.backgroundOverlay.alpha = 1
            self.drawerContainer.transform = .identity
        }
    }
    
    func hideDrawer(completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn) {
            self.backgroundOverlay.alpha = 0
            self.drawerContainer.transform = CGAffineTransform(translationX: -self.bounds.width * 0.85, y: 0)
        } completion: { _ in
            completion?()
        }
    }
}