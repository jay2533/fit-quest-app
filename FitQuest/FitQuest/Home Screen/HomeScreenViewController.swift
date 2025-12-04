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
    
    // All tasks
    var allTasks: [(name: String, category: String, time: String, completion: String)] = [
        ("Read 20 pages", "Mental", "Today 5:00 PM", "1/1"),
        ("Morning run", "Physical", "Today 7:00 PM", "0/1"),
        ("Meditate", "Mental", "Tomorrow 8:00 AM", "0/1"),
        ("Good diet", "Physical", "Today", "0/2"),
        ("Daily journal", "Creativity", "Today", "1/1")
    ]
    
    // Filtered tasks (for search)
    var filteredTasks: [(name: String, category: String, time: String, completion: String)] = []
    
    var isSearchActive = false
    
    override func loadView() {
        view = homeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        // Initialize filtered tasks with all tasks
        filteredTasks = allTasks
        
        homeView.tasksTableView.delegate = self
        homeView.tasksTableView.dataSource = self
        
        // Search functionality
        homeView.searchButton.addTarget(self, action: #selector(onSearchButtonTapped), for: .touchUpInside)
        homeView.searchTextField.delegate = self
        homeView.searchTextField.addTarget(self, action: #selector(searchTextChanged), for: .editingChanged)
        
        homeView.notificationButton.addTarget(self, action: #selector(onNotificationTapped), for: .touchUpInside)
        
        homeView.customClearButton.addTarget(self, action: #selector(clearSearchText), for: .touchUpInside)
        
        // Card tap gestures
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
        
        homeView.profileButton.addTarget(self, action: #selector(onProfileTapped), for: .touchUpInside)
        
        // Tap anywhere to dismiss search
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissSearch))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
        checkForUnreadNotifications()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        checkForUnreadNotifications()
    }
    
    @objc func onNotificationTapped() {
        let notificationVC = NotificationDrawerViewController()
        notificationVC.modalPresentationStyle = .overFullScreen
        notificationVC.modalTransitionStyle = .crossDissolve
        
        // Update badge after drawer is dismissed
        notificationVC.onDismiss = { [weak self] in
            self?.checkForUnreadNotifications()
        }
        
        present(notificationVC, animated: false)
    }
    
    
    @objc func onSearchButtonTapped() {
        if !isSearchActive {
            // Enter search mode
            isSearchActive = true
            homeView.showSearchMode()
        } else {
            // Exit search mode
            exitSearchMode()
        }
    }
    
    @objc func searchTextChanged() {
        guard let searchText = homeView.searchTextField.text else { return }
        
        if searchText.isEmpty {
            // Show all tasks
            filteredTasks = allTasks
        } else {
            // Filter tasks by name or category
            filteredTasks = allTasks.filter { task in
                task.name.lowercased().contains(searchText.lowercased()) ||
                task.category.lowercased().contains(searchText.lowercased())
            }
        }
        
        homeView.tasksTableView.reloadData()
    }
    
    // MARK: - Clear Search
    @objc func clearSearchText() {
        homeView.searchTextField.text = ""
        searchTextChanged() // Trigger filter update to show all tasks
        homeView.searchTextField.becomeFirstResponder() // Keep keyboard open
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
    
    // MARK: - Navigation actions
    
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
        // TODO: implement leaderboards screen
    }
    
    @objc func onProfileTapped() {
        // TODO: show notifications or settings
        let profileVC = ProfileViewController()
        navigationController?.pushViewController(profileVC, animated: true)
    }
    
    private func checkForUnreadNotifications() {
        guard let userId = authService.currentUserId else { return }
        
        Task {
            do {
                let unreadCount = try await NotificationService.shared.fetchUnreadCount(userId: userId)
                
                await MainActor.run {
                    homeView.updateNotificationBadge(hasUnread: unreadCount > 0)
                }
            } catch {
                print("Failed to check unread notifications: \(error.localizedDescription)")
            }
        }
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource

extension HomeScreenViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filteredTasks.isEmpty && isSearchActive {
            // Show empty state
            let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 100))
            messageLabel.text = "No tasks found"
            messageLabel.textColor = .lightGray
            messageLabel.textAlignment = .center
            messageLabel.font = .systemFont(ofSize: 16, weight: .regular)
            tableView.backgroundView = messageLabel
        } else {
            tableView.backgroundView = nil
        }
        
        return filteredTasks.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: TaskTableViewCell.identifier,
            for: indexPath
        ) as? TaskTableViewCell else {
            return UITableViewCell()
        }
        
        let task = filteredTasks[indexPath.row]
        cell.taskNameLabel.text = task.name
        cell.categoryBadge.text = task.category
        cell.timeLabel.text = task.time
        cell.completionLabel.text = task.completion
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView,
                   estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 96
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = filteredTasks[indexPath.row]
        // TODO: navigate to task details
    }
}

// MARK: - UITextFieldDelegate

extension HomeScreenViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // Prevent tap gesture from dismissing when tapping in search field
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
}
