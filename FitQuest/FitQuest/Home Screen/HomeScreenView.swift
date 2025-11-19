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
    
    // MARK: - Feature Cards
    var calendarCardView: UIView!
    var taskHistoryCardView: UIView!
    var statsCardView: UIView!
    var rewardsCardView: UIView!
    
    // Card contents
    var calendarIconView: UIImageView!
    var calendarLabel: UILabel!
    
    var taskHistoryIconView: UIImageView!
    var taskHistoryLabel: UILabel!
    
    var statsIconView: UIImageView!
    var statsLabel: UILabel!
    
    var rewardsIconView: UIImageView!
    var rewardsLabel: UILabel!
    
    // MARK: - Due Tasks Header
    var dueTasksContainer: UIView!
    var dueTasksIconView: UIImageView!
    var dueTasksLabel: UILabel!
    
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
        // Logo from asset catalog (replace "fitquest_logo" with your image name)
        logoImageView = UIImageView()
        logoImageView.contentMode = .scaleAspectFit
        // Using SF Symbol as placeholder
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
        
        notificationButton = UIButton(type: .system)
        let bellConfig = UIImage.SymbolConfiguration(pointSize: 22, weight: .regular)
        notificationButton.setImage(UIImage(systemName: "bell", withConfiguration: bellConfig), for: .normal)
        notificationButton.tintColor = UIColor(red: 0.62, green: 0.79, blue: 0.97, alpha: 1.0)
        notificationButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(notificationButton)
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
        rewardsCardView = makeCardView()
        
        self.addSubview(calendarCardView)
        self.addSubview(taskHistoryCardView)
        self.addSubview(statsCardView)
        self.addSubview(rewardsCardView)
        
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
        
        // Rewards
        rewardsIconView = UIImageView()
        rewardsIconView.contentMode = .scaleAspectFit
        rewardsIconView.image = UIImage(systemName: "trophy.fill")
        rewardsIconView.tintColor = UIColor(red: 0.62, green: 0.79, blue: 0.97, alpha: 1.0)
        rewardsIconView.translatesAutoresizingMaskIntoConstraints = false
        rewardsCardView.addSubview(rewardsIconView)
        
        rewardsLabel = UILabel()
        rewardsLabel.text = "Rewards"
        rewardsLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        rewardsLabel.textColor = .white
        rewardsLabel.textAlignment = .center
        rewardsLabel.translatesAutoresizingMaskIntoConstraints = false
        rewardsCardView.addSubview(rewardsLabel)
    }
    
    func setupDueTasksHeader() {
        dueTasksContainer = UIView()
        dueTasksContainer.backgroundColor = UIColor.white.withAlphaComponent(0.05)
        dueTasksContainer.layer.cornerRadius = 16
        dueTasksContainer.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(dueTasksContainer)
        
        dueTasksIconView = UIImageView()
        dueTasksIconView.contentMode = .scaleAspectFit
        dueTasksIconView.image = UIImage(systemName: "magnifyingglass")
        dueTasksIconView.tintColor = .white
        dueTasksIconView.translatesAutoresizingMaskIntoConstraints = false
        dueTasksContainer.addSubview(dueTasksIconView)
        
        dueTasksLabel = UILabel()
        dueTasksLabel.text = "Due tasks"
        dueTasksLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        dueTasksLabel.textColor = .white
        dueTasksLabel.translatesAutoresizingMaskIntoConstraints = false
        dueTasksContainer.addSubview(dueTasksLabel)
        
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
        
        dueTasksContainer.addSubview(powerLevelStack)
        dueTasksContainer.addSubview(powerLevelBar)
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
            notificationButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -24),
            notificationButton.widthAnchor.constraint(equalToConstant: 32),
            notificationButton.heightAnchor.constraint(equalToConstant: 32),
            
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
            
            rewardsCardView.topAnchor.constraint(equalTo: taskHistoryCardView.bottomAnchor, constant: 16),
            rewardsCardView.leadingAnchor.constraint(equalTo: self.centerXAnchor, constant: 8),
            rewardsCardView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            rewardsCardView.heightAnchor.constraint(equalToConstant: 110),
            
            // Icons + labels inside cards
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
            
            rewardsIconView.topAnchor.constraint(equalTo: rewardsCardView.topAnchor, constant: 18),
            rewardsIconView.centerXAnchor.constraint(equalTo: rewardsCardView.centerXAnchor),
            rewardsIconView.widthAnchor.constraint(equalToConstant: 32),
            rewardsIconView.heightAnchor.constraint(equalToConstant: 32),
            
            rewardsLabel.topAnchor.constraint(equalTo: rewardsIconView.bottomAnchor, constant: 8),
            rewardsLabel.leadingAnchor.constraint(equalTo: rewardsCardView.leadingAnchor, constant: 8),
            rewardsLabel.trailingAnchor.constraint(equalTo: rewardsCardView.trailingAnchor, constant: -8),
            
            // Due tasks container
            dueTasksContainer.topAnchor.constraint(equalTo: statsCardView.bottomAnchor, constant: 24),
            dueTasksContainer.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            dueTasksContainer.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            dueTasksContainer.heightAnchor.constraint(equalToConstant: 70),
            
            dueTasksIconView.leadingAnchor.constraint(equalTo: dueTasksContainer.leadingAnchor, constant: 16),
            dueTasksIconView.centerYAnchor.constraint(equalTo: dueTasksContainer.centerYAnchor),
            dueTasksIconView.widthAnchor.constraint(equalToConstant: 20),
            dueTasksIconView.heightAnchor.constraint(equalToConstant: 20),
            
            dueTasksLabel.leadingAnchor.constraint(equalTo: dueTasksIconView.trailingAnchor, constant: 8),
            dueTasksLabel.centerYAnchor.constraint(equalTo: dueTasksContainer.centerYAnchor),
            
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

