//
//  HomeScreenView.swift
//  FitQuest
//
//  Created by Rushad Daruwalla on 11/18/25.
//

import UIKit

class HomeScreenView: UIView {
    
    // MARK: - Header
    var logoImageView: UIImageView!
    var appNameLabel: UILabel!
    var notificationButton: UIButton!
    var notificationBadge: UIView!
    var profileButton: UIButton!

    // MARK: - Feature Cards
    var calendarCardView: UIView!
    var taskHistoryCardView: UIView!
    var statsCardView: UIView!
    var leaderboardsCardView: UIView!
    
    // Card contents
    var calendarIconView: UIImageView!
    var calendarLabel: UILabel!
    
    var taskHistoryIconView: UIImageView!
    var taskHistoryLabel: UILabel!
    
    var statsIconView: UIImageView!
    var statsLabel: UILabel!
    
    var leaderboardsIconView: UIImageView!
    var leaderboardsLabel: UILabel!
    
    // MARK: - Due Tasks Header
    var dueTasksContainer: UIView!
    var searchButton: UIButton!
    var dueTasksLabel: UILabel!
    var searchTextField: UITextField!
    var customClearButton: UIButton!
    
    var powerLevelStack: UIStackView!
    var powerLevelTitleLabel: UILabel!
    var powerLevelValueLabel: UILabel!
    var powerLevelBar: UIProgressView!
    
    // MARK: - Tasks Table
    var tasksTableView: UITableView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(red: 0.08, green: 0.15, blue: 0.25, alpha: 1.0)
        
        setupHeader()
        setupFeatureCards()
        setupDueTasksHeader()
        setupTasksTableView()
        
        initConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    func setupHeader() {
        logoImageView = UIImageView()
        logoImageView.contentMode = .scaleAspectFit
        let config = UIImage.SymbolConfiguration(pointSize: 80, weight: .medium)
        logoImageView.image = UIImage(systemName: "arrow.up.heart.fill", withConfiguration: config)
        logoImageView.tintColor = UIColor(red: 0.33, green: 0.67, blue: 0.93, alpha: 1.0)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(logoImageView)
        
        appNameLabel = UILabel()
        appNameLabel.text = "FITQUEST"
        appNameLabel.font = .systemFont(ofSize: 26, weight: .bold)
        appNameLabel.textColor = .white
        appNameLabel.textAlignment = .center
        appNameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(appNameLabel)
        
        // Notification Bell Button
        notificationButton = UIButton(type: .system)
        let notificationConfig = UIImage.SymbolConfiguration(pointSize: 28, weight: .medium)
        notificationButton.setImage(UIImage(systemName: "bell.fill", withConfiguration: notificationConfig), for: .normal)
        notificationButton.tintColor = UIColor(red: 0.33, green: 0.67, blue: 0.93, alpha: 1.0)
        notificationButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(notificationButton)
        
        // Red Badge Indicator
        notificationBadge = UIView()
        notificationBadge.backgroundColor = .systemRed
        notificationBadge.layer.cornerRadius = 6
        notificationBadge.isHidden = true  // Hidden by default
        notificationBadge.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(notificationBadge)
        
        profileButton = UIButton(type: .system)
        let profileConfig = UIImage.SymbolConfiguration(pointSize: 28, weight: .medium)
        profileButton.setImage(UIImage(systemName: "person.circle.fill", withConfiguration: profileConfig), for: .normal)
        profileButton.tintColor = UIColor(red: 0.33, green: 0.67, blue: 0.93, alpha: 1.0)
        profileButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(profileButton)
    }
    
    func makeCardView() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.05)
        view.layer.cornerRadius = 18
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(red: 0.16, green: 0.34, blue: 0.57, alpha: 0.7).cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    func setupFeatureCards() {
        calendarCardView = makeCardView()
        taskHistoryCardView = makeCardView()
        statsCardView = makeCardView()
        leaderboardsCardView = makeCardView()
        
        self.addSubview(calendarCardView)
        self.addSubview(taskHistoryCardView)
        self.addSubview(statsCardView)
        self.addSubview(leaderboardsCardView)
        
        // Calendar
        calendarIconView = UIImageView()
        calendarIconView.contentMode = .scaleAspectFit
        calendarIconView.image = UIImage(systemName: "calendar")
        calendarIconView.tintColor = UIColor(red: 0.62, green: 0.79, blue: 0.97, alpha: 1.0)
        calendarIconView.translatesAutoresizingMaskIntoConstraints = false
        calendarCardView.addSubview(calendarIconView)
        
        calendarLabel = UILabel()
        calendarLabel.text = "Calendar"
        calendarLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        calendarLabel.textColor = .white
        calendarLabel.textAlignment = .center
        calendarLabel.translatesAutoresizingMaskIntoConstraints = false
        calendarCardView.addSubview(calendarLabel)
        
        // Task History
        taskHistoryIconView = UIImageView()
        taskHistoryIconView.contentMode = .scaleAspectFit
        taskHistoryIconView.image = UIImage(systemName: "checklist")
        taskHistoryIconView.tintColor = UIColor(red: 0.62, green: 0.79, blue: 0.97, alpha: 1.0)
        taskHistoryIconView.translatesAutoresizingMaskIntoConstraints = false
        taskHistoryCardView.addSubview(taskHistoryIconView)
        
        taskHistoryLabel = UILabel()
        taskHistoryLabel.text = "Task History"
        taskHistoryLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        taskHistoryLabel.textColor = .white
        taskHistoryLabel.textAlignment = .center
        taskHistoryLabel.translatesAutoresizingMaskIntoConstraints = false
        taskHistoryCardView.addSubview(taskHistoryLabel)
        
        // Stats
        statsIconView = UIImageView()
        statsIconView.contentMode = .scaleAspectFit
        statsIconView.image = UIImage(systemName: "chart.bar.fill")
        statsIconView.tintColor = UIColor(red: 0.62, green: 0.79, blue: 0.97, alpha: 1.0)
        statsIconView.translatesAutoresizingMaskIntoConstraints = false
        statsCardView.addSubview(statsIconView)
        
        statsLabel = UILabel()
        statsLabel.text = "Stats"
        statsLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        statsLabel.textColor = .white
        statsLabel.textAlignment = .center
        statsLabel.translatesAutoresizingMaskIntoConstraints = false
        statsCardView.addSubview(statsLabel)
        
        // Leaderboards
        leaderboardsIconView = UIImageView()
        leaderboardsIconView.contentMode = .scaleAspectFit
        leaderboardsIconView.image = UIImage(systemName: "list.number")
        leaderboardsIconView.tintColor = UIColor(red: 0.62, green: 0.79, blue: 0.97, alpha: 1.0)
        leaderboardsIconView.translatesAutoresizingMaskIntoConstraints = false
        leaderboardsCardView.addSubview(leaderboardsIconView)
        
        leaderboardsLabel = UILabel()
        leaderboardsLabel.text = "Leaderboards"
        leaderboardsLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        leaderboardsLabel.textColor = .white
        leaderboardsLabel.textAlignment = .center
        leaderboardsLabel.translatesAutoresizingMaskIntoConstraints = false
        leaderboardsCardView.addSubview(leaderboardsLabel)
    }
    
    func setupDueTasksHeader() {
        dueTasksContainer = UIView()
        dueTasksContainer.backgroundColor = UIColor.white.withAlphaComponent(0.05)
        dueTasksContainer.layer.cornerRadius = 16
        dueTasksContainer.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(dueTasksContainer)
        
        // Search Button
        searchButton = UIButton(type: .system)
        searchButton.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        searchButton.tintColor = .white
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        dueTasksContainer.addSubview(searchButton)
        
        dueTasksLabel = UILabel()
        dueTasksLabel.text = "Due tasks"
        dueTasksLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        dueTasksLabel.textColor = .white
        dueTasksLabel.translatesAutoresizingMaskIntoConstraints = false
        dueTasksContainer.addSubview(dueTasksLabel)
        
        // Search TextField
        searchTextField = UITextField()
        searchTextField.placeholder = "Search tasks..."
        searchTextField.textColor = .white
        searchTextField.font = .systemFont(ofSize: 16)
        searchTextField.backgroundColor = .clear
        searchTextField.returnKeyType = .search
        searchTextField.clearButtonMode = .never
        searchTextField.alpha = 0
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        
        searchTextField.attributedPlaceholder = NSAttributedString(
            string: "Search tasks...",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        )
        
        dueTasksContainer.addSubview(searchTextField)
        
        // Custom Clear Button - WHITE and VISIBLE
        customClearButton = UIButton(type: .custom)  // Changed to .custom
        
        // White background circle
        customClearButton.backgroundColor = .white
        customClearButton.layer.cornerRadius = 12
        
        // Dark X icon for contrast
        let xIcon = UIImage(systemName: "xmark", withConfiguration: UIImage.SymbolConfiguration(pointSize: 10, weight: .bold))
        customClearButton.setImage(xIcon, for: .normal)
        customClearButton.tintColor = UIColor(red: 0.08, green: 0.15, blue: 0.25, alpha: 1.0)
        
        customClearButton.alpha = 0  // Hidden initially
        customClearButton.translatesAutoresizingMaskIntoConstraints = false
        
        dueTasksContainer.addSubview(customClearButton)
        
        powerLevelTitleLabel = UILabel()
        powerLevelTitleLabel.text = "Power level"
        powerLevelTitleLabel.font = .systemFont(ofSize: 12, weight: .medium)
        powerLevelTitleLabel.textColor = .lightGray
        
        powerLevelValueLabel = UILabel()
        powerLevelValueLabel.text = "250"
        powerLevelValueLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        powerLevelValueLabel.textColor = .white
        
        powerLevelBar = UIProgressView(progressViewStyle: .default)
        powerLevelBar.progress = 0.5
        powerLevelBar.translatesAutoresizingMaskIntoConstraints = false
        
        powerLevelStack = UIStackView(arrangedSubviews: [powerLevelTitleLabel, powerLevelValueLabel])
        powerLevelStack.axis = .vertical
        powerLevelStack.spacing = 2
        powerLevelStack.alignment = .trailing
        powerLevelStack.translatesAutoresizingMaskIntoConstraints = false
        
        // Add power level BEFORE clear button in subview hierarchy
        dueTasksContainer.insertSubview(powerLevelStack, at: 0)
        dueTasksContainer.insertSubview(powerLevelBar, at: 0)
    }
    
    func setupTasksTableView() {
        tasksTableView = UITableView()
        tasksTableView.backgroundColor = .clear
        tasksTableView.separatorStyle = .none
        tasksTableView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(tasksTableView)
        
        tasksTableView.register(TaskTableViewCell.self,
                                forCellReuseIdentifier: TaskTableViewCell.identifier)
    }
    
    // MARK: - Search State Toggle
    func showSearchMode() {
        UIView.animate(withDuration: 0.3) {
            self.dueTasksLabel.alpha = 0
            self.powerLevelStack.alpha = 0
            self.powerLevelBar.alpha = 0
            self.searchTextField.alpha = 1
            self.customClearButton.alpha = 1
        } completion: { _ in
            self.searchTextField.becomeFirstResponder()
        }
    }
    
    func hideSearchMode() {
        searchTextField.text = ""
        searchTextField.resignFirstResponder()
        
        UIView.animate(withDuration: 0.3) {
            self.searchTextField.alpha = 0
            self.customClearButton.alpha = 0
            self.dueTasksLabel.alpha = 1
            self.powerLevelStack.alpha = 1
            self.powerLevelBar.alpha = 1
        }
    }
    
    func updateNotificationBadge(hasUnread: Bool) {
        UIView.animate(withDuration: 0.2) {
            self.notificationBadge.isHidden = !hasUnread
        }
    }
    
    // MARK: - Constraints
    func initConstraints() {
        NSLayoutConstraint.activate([
            // Header
            logoImageView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 20),
            logoImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 80),
            logoImageView.heightAnchor.constraint(equalToConstant: 80),
            
            appNameLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 8),
            appNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 40),
            appNameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -40),
            
            notificationButton.centerYAnchor.constraint(equalTo: logoImageView.centerYAnchor),
            notificationButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 24),
            notificationButton.widthAnchor.constraint(equalToConstant: 32),
            notificationButton.heightAnchor.constraint(equalToConstant: 32),

            // Red Badge
            notificationBadge.topAnchor.constraint(equalTo: notificationButton.topAnchor, constant: 2),
            notificationBadge.trailingAnchor.constraint(equalTo: notificationButton.trailingAnchor, constant: 2),
            notificationBadge.widthAnchor.constraint(equalToConstant: 12),
            notificationBadge.heightAnchor.constraint(equalToConstant: 12),
            
            profileButton.centerYAnchor.constraint(equalTo: logoImageView.centerYAnchor),
            profileButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -24),
            profileButton.widthAnchor.constraint(equalToConstant: 32),
            profileButton.heightAnchor.constraint(equalToConstant: 32),
                
            // Top row cards
            calendarCardView.topAnchor.constraint(equalTo: appNameLabel.bottomAnchor, constant: 24),
            calendarCardView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            calendarCardView.trailingAnchor.constraint(equalTo: self.centerXAnchor, constant: -8),
            calendarCardView.heightAnchor.constraint(equalToConstant: 110),
            
            taskHistoryCardView.topAnchor.constraint(equalTo: appNameLabel.bottomAnchor, constant: 24),
            taskHistoryCardView.leadingAnchor.constraint(equalTo: self.centerXAnchor, constant: 8),
            taskHistoryCardView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            taskHistoryCardView.heightAnchor.constraint(equalToConstant: 110),
            
            // Bottom row cards
            statsCardView.topAnchor.constraint(equalTo: calendarCardView.bottomAnchor, constant: 16),
            statsCardView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            statsCardView.trailingAnchor.constraint(equalTo: self.centerXAnchor, constant: -8),
            statsCardView.heightAnchor.constraint(equalToConstant: 110),
            
            leaderboardsCardView.topAnchor.constraint(equalTo: taskHistoryCardView.bottomAnchor, constant: 16),
            leaderboardsCardView.leadingAnchor.constraint(equalTo: self.centerXAnchor, constant: 8),
            leaderboardsCardView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            leaderboardsCardView.heightAnchor.constraint(equalToConstant: 110),

            // Icons + labels inside cards
            leaderboardsIconView.topAnchor.constraint(equalTo: leaderboardsCardView.topAnchor, constant: 18),
            leaderboardsIconView.centerXAnchor.constraint(equalTo: leaderboardsCardView.centerXAnchor),
            leaderboardsIconView.widthAnchor.constraint(equalToConstant: 32),
            leaderboardsIconView.heightAnchor.constraint(equalToConstant: 32),

            leaderboardsLabel.topAnchor.constraint(equalTo: leaderboardsIconView.bottomAnchor, constant: 8),
            leaderboardsLabel.leadingAnchor.constraint(equalTo: leaderboardsCardView.leadingAnchor, constant: 8),
            leaderboardsLabel.trailingAnchor.constraint(equalTo: leaderboardsCardView.trailingAnchor, constant: -8),
            
            calendarIconView.topAnchor.constraint(equalTo: calendarCardView.topAnchor, constant: 18),
            calendarIconView.centerXAnchor.constraint(equalTo: calendarCardView.centerXAnchor),
            calendarIconView.widthAnchor.constraint(equalToConstant: 32),
            calendarIconView.heightAnchor.constraint(equalToConstant: 32),
            
            calendarLabel.topAnchor.constraint(equalTo: calendarIconView.bottomAnchor, constant: 8),
            calendarLabel.leadingAnchor.constraint(equalTo: calendarCardView.leadingAnchor, constant: 8),
            calendarLabel.trailingAnchor.constraint(equalTo: calendarCardView.trailingAnchor, constant: -8),
            
            taskHistoryIconView.topAnchor.constraint(equalTo: taskHistoryCardView.topAnchor, constant: 18),
            taskHistoryIconView.centerXAnchor.constraint(equalTo: taskHistoryCardView.centerXAnchor),
            taskHistoryIconView.widthAnchor.constraint(equalToConstant: 32),
            taskHistoryIconView.heightAnchor.constraint(equalToConstant: 32),
            
            taskHistoryLabel.topAnchor.constraint(equalTo: taskHistoryIconView.bottomAnchor, constant: 8),
            taskHistoryLabel.leadingAnchor.constraint(equalTo: taskHistoryCardView.leadingAnchor, constant: 8),
            taskHistoryLabel.trailingAnchor.constraint(equalTo: taskHistoryCardView.trailingAnchor, constant: -8),
            
            statsIconView.topAnchor.constraint(equalTo: statsCardView.topAnchor, constant: 18),
            statsIconView.centerXAnchor.constraint(equalTo: statsCardView.centerXAnchor),
            statsIconView.widthAnchor.constraint(equalToConstant: 32),
            statsIconView.heightAnchor.constraint(equalToConstant: 32),
            
            statsLabel.topAnchor.constraint(equalTo: statsIconView.bottomAnchor, constant: 8),
            statsLabel.leadingAnchor.constraint(equalTo: statsCardView.leadingAnchor, constant: 8),
            statsLabel.trailingAnchor.constraint(equalTo: statsCardView.trailingAnchor, constant: -8),
            
            // Due tasks container
            dueTasksContainer.topAnchor.constraint(equalTo: statsCardView.bottomAnchor, constant: 24),
            dueTasksContainer.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            dueTasksContainer.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            dueTasksContainer.heightAnchor.constraint(equalToConstant: 70),
            
            // Search Button
            searchButton.leadingAnchor.constraint(equalTo: dueTasksContainer.leadingAnchor, constant: 16),
            searchButton.centerYAnchor.constraint(equalTo: dueTasksContainer.centerYAnchor),
            searchButton.widthAnchor.constraint(equalToConstant: 20),
            searchButton.heightAnchor.constraint(equalToConstant: 20),
            
            dueTasksLabel.leadingAnchor.constraint(equalTo: searchButton.trailingAnchor, constant: 8),
            dueTasksLabel.centerYAnchor.constraint(equalTo: dueTasksContainer.centerYAnchor),
            
            // Search TextField - with right padding for clear button
            searchTextField.leadingAnchor.constraint(equalTo: searchButton.trailingAnchor, constant: 8),
            searchTextField.trailingAnchor.constraint(equalTo: customClearButton.leadingAnchor, constant: -8),
            searchTextField.centerYAnchor.constraint(equalTo: dueTasksContainer.centerYAnchor),

            
            // Custom Clear Button (Fixed at right, before power level)
            customClearButton.trailingAnchor.constraint(equalTo: dueTasksContainer.trailingAnchor, constant: -16),
            customClearButton.centerYAnchor.constraint(equalTo: dueTasksContainer.centerYAnchor),
            customClearButton.widthAnchor.constraint(equalToConstant: 24),
            customClearButton.heightAnchor.constraint(equalToConstant: 24),
            
            powerLevelStack.trailingAnchor.constraint(equalTo: dueTasksContainer.trailingAnchor, constant: -16),
            powerLevelStack.topAnchor.constraint(equalTo: dueTasksContainer.topAnchor, constant: 10),
            
            powerLevelBar.leadingAnchor.constraint(equalTo: powerLevelStack.leadingAnchor),
            powerLevelBar.trailingAnchor.constraint(equalTo: powerLevelStack.trailingAnchor),
            powerLevelBar.topAnchor.constraint(equalTo: powerLevelStack.bottomAnchor, constant: 4),
            powerLevelBar.bottomAnchor.constraint(equalTo: dueTasksContainer.bottomAnchor, constant: -10),
            
            // Tasks table
            tasksTableView.topAnchor.constraint(equalTo: dueTasksContainer.bottomAnchor, constant: 12),
            tasksTableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            tasksTableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            tasksTableView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
