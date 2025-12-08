//
//  HomeScreenViewController.swift
//  FitQuest
//
//  Created by Rushad Daruwalla on 11/18/25.
//

import UIKit

class HomeScreenViewController: UIViewController {
    
    let homeView = HomeScreenView()
    private let authService = AuthService.shared
    private let taskService = TaskService.shared
    
    // Real tasks from Firestore
    var allTasks: [FitQuestTask] = []
    var filteredTasks: [FitQuestTask] = []
    
    var isSearchActive = false
    
    override func loadView() {
        view = homeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        homeView.tasksTableView.delegate = self
        homeView.tasksTableView.dataSource = self
        
        // Search functionality
        homeView.searchButton.addTarget(self, action: #selector(onSearchButtonTapped), for: .touchUpInside)
        homeView.searchTextField.delegate = self
        homeView.searchTextField.addTarget(self, action: #selector(searchTextChanged), for: .editingChanged)
        homeView.customClearButton.addTarget(self, action: #selector(clearSearchText), for: .touchUpInside)
        
        // Notification button
        homeView.notificationButton.addTarget(self, action: #selector(onNotificationTapped), for: .touchUpInside)
        
        // Card tap gestures
        setupCardGestures()
        
        homeView.profileButton.addTarget(self, action: #selector(onProfileTapped), for: .touchUpInside)
        
        // Tap anywhere to dismiss search
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissSearch))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
        // Load tasks from Firestore
        loadDueTasks()
        checkForUnreadNotifications()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        // Reload tasks when returning to this screen
        loadDueTasks()
        checkForUnreadNotifications()
    }
    
    // MARK: - Setup
    
    private func setupCardGestures() {
        let calendarTap = UITapGestureRecognizer(target: self, action: #selector(onCalendarTapped))
        homeView.calendarCardView.addGestureRecognizer(calendarTap)
        
        let historyTap = UITapGestureRecognizer(target: self, action: #selector(onTaskHistoryTapped))
        homeView.taskHistoryCardView.addGestureRecognizer(historyTap)
        
        let statsTap = UITapGestureRecognizer(target: self, action: #selector(onStatsTapped))
        homeView.statsCardView.addGestureRecognizer(statsTap)
        
        let leaderboardsTap = UITapGestureRecognizer(target: self, action: #selector(onLeaderboardsTapped))
        homeView.leaderboardsCardView.addGestureRecognizer(leaderboardsTap)
        
        homeView.calendarCardView.isUserInteractionEnabled = true
        homeView.taskHistoryCardView.isUserInteractionEnabled = true
        homeView.statsCardView.isUserInteractionEnabled = true
        homeView.leaderboardsCardView.isUserInteractionEnabled = true
    }
    
    // MARK: - Load Tasks from Firestore
    
    private func loadDueTasks() {
        guard let userId = authService.currentUserId else { return }
        
        Task {
            do {
                let activeTasks = try await taskService.fetchActiveTasks(userId: userId)
                print("📦 Fetched \(activeTasks.count) active tasks")
                
                let calendar = Calendar.current
                let now = Date()
                
                // Get today's date components (year, month, day only)
                let todayComponents = calendar.dateComponents([.year, .month, .day], from: now)
                
                let dueTodayTasks = activeTasks.filter { task in
                    // Get task's date components
                    let taskComponents = calendar.dateComponents([.year, .month, .day], from: task.scheduledDate)
                    
                    // Compare only year, month, day (ignore time)
                    let isDueToday = todayComponents.year == taskComponents.year &&
                                     todayComponents.month == taskComponents.month &&
                                     todayComponents.day == taskComponents.day
                    
                    print("   \(task.title): \(taskComponents.month ?? 0)/\(taskComponents.day ?? 0) vs Today: \(todayComponents.month ?? 0)/\(todayComponents.day ?? 0) = \(isDueToday)")
                    
                    return isDueToday
                }
                
                print("✅ Found \(dueTodayTasks.count) tasks due today")
                
                let sortedTasks = dueTodayTasks.sorted { $0.scheduledTime < $1.scheduledTime }
                
                await MainActor.run {
                    self.allTasks = sortedTasks
                    self.filteredTasks = sortedTasks
                    self.homeView.tasksTableView.reloadData()
                }
                
            } catch {
                print("❌ Error: \(error)")
            }
        }
    }
    
    // MARK: - Search Actions
    
    @objc func onSearchButtonTapped() {
        if !isSearchActive {
            isSearchActive = true
            homeView.showSearchMode()
        } else {
            exitSearchMode()
        }
    }
    
    @objc func searchTextChanged() {
        guard let searchText = homeView.searchTextField.text else { return }
        
        if searchText.isEmpty {
            // Show all tasks
            filteredTasks = allTasks
        } else {
            // Filter tasks by title or category
            filteredTasks = allTasks.filter { task in
                task.title.lowercased().contains(searchText.lowercased()) ||
                task.category.rawValue.lowercased().contains(searchText.lowercased())
            }
        }
        
        homeView.tasksTableView.reloadData()
    }
    
    @objc func clearSearchText() {
        homeView.searchTextField.text = ""
        searchTextChanged()
        homeView.searchTextField.becomeFirstResponder()
    }
    
    @objc func dismissSearch() {
        if isSearchActive {
            exitSearchMode()
        }
    }
    
    func exitSearchMode() {
        isSearchActive = false
        filteredTasks = allTasks
        homeView.hideSearchMode()
        homeView.tasksTableView.reloadData()
    }
    
    // MARK: - Notification Actions
    
    @objc func onNotificationTapped() {
        let notificationVC = NotificationDrawerViewController()
        notificationVC.modalPresentationStyle = .overFullScreen
        notificationVC.modalTransitionStyle = .crossDissolve
        
        notificationVC.onDismiss = { [weak self] in
            self?.checkForUnreadNotifications()
        }
        
        present(notificationVC, animated: false)
    }
    
    private func checkForUnreadNotifications() {
        guard let userId = authService.currentUserId else { return }
        
        Task {
            do {
                // Use the new total count method
                let totalUnread = try await NotificationService.shared.fetchTotalUnreadCount(userId: userId)
                
                await MainActor.run {
                    homeView.updateNotificationBadge(hasUnread: totalUnread > 0)
                }
            } catch {
                print("Failed to check notifications: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Navigation Actions
    
    @objc func onCalendarTapped() {
        let calendarVC = CalendarScreenViewController()
        navigationController?.pushViewController(calendarVC, animated: true)
    }
    
    @objc func onTaskHistoryTapped() {
        let historyVC = HistoryScreenViewController()
        navigationController?.pushViewController(historyVC, animated: true)
    }
    
    @objc func onStatsTapped() {
        let statsVC = StatsScreenViewController()
        navigationController?.pushViewController(statsVC, animated: true)
    }
    
    @objc func onLeaderboardsTapped() {
        print("Leaderboards tapped")
        // TODO: implement leaderboards screen
    }
    
    @objc func onProfileTapped() {
        let profileVC = ProfileViewController()
        navigationController?.pushViewController(profileVC, animated: true)
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource

extension HomeScreenViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Show empty state if no tasks
        if filteredTasks.isEmpty {
            let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 100))
            
            if isSearchActive {
                messageLabel.text = "No tasks found"
            } else {
                messageLabel.text = "No tasks due today"
            }
            
            messageLabel.textColor = .lightGray
            messageLabel.textAlignment = .center
            messageLabel.font = .systemFont(ofSize: 16, weight: .regular)
            tableView.backgroundView = messageLabel
        } else {
            tableView.backgroundView = nil
        }
        
        return filteredTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: TaskTableViewCell.identifier,
            for: indexPath
        ) as? TaskTableViewCell else {
            return UITableViewCell()
        }
        
        let task = filteredTasks[indexPath.row]
        
        // Configure cell with real task data
        cell.configure(with: task, isCompleted: task.isCompleted)
        
        // Handle checkbox tap
        cell.onCheckboxTapped = { [weak self] in
            self?.handleTaskCompletion(task: task, at: indexPath)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 78  // Fixed height from your cell design
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = filteredTasks[indexPath.row]
        print("Task tapped: \(task.title)")
        // TODO: Navigate to task detail screen
    }
    
    // MARK: - Task Completion
    private func handleTaskCompletion(task: FitQuestTask, at indexPath: IndexPath) {
        guard let taskId = task.id, let userId = authService.currentUserId else { return }
        
        Task {
            do {
                let newCompletionStatus = !task.isCompleted
                
                if newCompletionStatus {
                    // Mark as complete
                    try await taskService.completeTask(taskId: taskId)
                    
                    // Update stats
                    try await StatsService.shared.updateStatsAfterTaskCompletion(userId: userId, task: task)
                    
                    // 🔥 Clear read state since task is now complete
                    NotificationStateManager.shared.clearReadStateForTask(userId: userId, taskId: taskId)
                } else {
                    // Mark as incomplete
                    try await taskService.updateTask(taskId: taskId, updates: [
                        "isCompleted": false,
                        "completedAt": NSNull()
                    ])
                }
                
                await MainActor.run {
                    if let cell = self.homeView.tasksTableView.cellForRow(at: indexPath) as? TaskTableViewCell {
                        cell.updateCompletionState(isCompleted: newCompletionStatus, animated: true)
                    }
                    
                    self.loadDueTasks()
                    self.checkForUnreadNotifications() // 🔥 Update badge
                }
                
            } catch {
                await MainActor.run {
                    print("Failed to update task: \(error.localizedDescription)")
                }
            }
        }
    }
}

// MARK: - UITextFieldDelegate

extension HomeScreenViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
}
