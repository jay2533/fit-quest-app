//
//  HomeScreenViewController.swift
//  FitQuest
//
//  Created by Rushad Daruwalla on 11/18/25.
//

import UIKit
import FirebaseFirestore

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
        
        homeView.searchButton.addTarget(self, action: #selector(onSearchButtonTapped), for: .touchUpInside)
        homeView.searchTextField.delegate = self
        homeView.searchTextField.addTarget(self, action: #selector(searchTextChanged), for: .editingChanged)
        homeView.customClearButton.addTarget(self, action: #selector(clearSearchText), for: .touchUpInside)
        
        homeView.notificationButton.addTarget(self, action: #selector(onNotificationTapped), for: .touchUpInside)
        
        setupCardGestures()
        
        homeView.profileButton.addTarget(self, action: #selector(onProfileTapped), for: .touchUpInside)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissSearch))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
        loadDueTasks()
        checkForUnreadNotifications()
        loadUserAIAvatar()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        loadDueTasks()
        checkForUnreadNotifications()
        loadUserAIAvatar()
    }
        
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
    
    private func loadUserAIAvatar() {
        guard let userId = authService.currentUserId else { return }
        
        Task {
            do {
                // Fetch user name from Firestore
                let document = try await Firestore.firestore()
                    .collection("users")
                    .document(userId)
                    .getDocument()
                
                guard let data = document.data(),
                      let name = data["name"] as? String else {
                    await MainActor.run {
                        self.setAIAvatar(name: "User")
                    }
                    return
                }
                
                // Generate AI avatar
                await MainActor.run {
                    self.setAIAvatar(name: name)
                }
                
            } catch {
                await MainActor.run {
                    self.setAIAvatar(name: "User")
                }
            }
        }
    }
    
    private func setAIAvatar(name: String) {
        Task {
            let avatar = await AvatarGenerator.shared.getAIAvatar(name: name, size: 44)
            
            await MainActor.run {
                self.homeView.updateProfileImage(with: avatar)
            }
        }
    }
        
    private func loadDueTasks() {
        guard let userId = authService.currentUserId else {
            return
        }
        
        Task {
            do {
                // Fetch all active tasks
                let activeTasks = try await taskService.fetchActiveTasks(userId: userId)
                
                // Get today's date components
                let calendar = Calendar.current
                let now = Date()
                let todayComponents = calendar.dateComponents([.year, .month, .day], from: now)
                
                // Filter tasks due today
                let dueTodayTasks = activeTasks.filter { task in
                    let taskComponents = calendar.dateComponents([.year, .month, .day], from: task.scheduledDate)
                    
                    return todayComponents.year == taskComponents.year &&
                           todayComponents.month == taskComponents.month &&
                           todayComponents.day == taskComponents.day
                }
                
                // Sort by scheduled time
                let sortedTasks = dueTodayTasks.sorted { $0.scheduledTime < $1.scheduledTime }
                
                await MainActor.run {
                    self.allTasks = sortedTasks
                    self.filteredTasks = sortedTasks
                    self.homeView.tasksTableView.reloadData()
                }
                
            } catch {
                await MainActor.run {
                    self.allTasks = []
                    self.filteredTasks = []
                    self.homeView.tasksTableView.reloadData()
                }
            }
        }
    }
        
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
            filteredTasks = allTasks
        } else {
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
                let totalUnread = try await NotificationService.shared.fetchTotalUnreadCount(userId: userId)
                
                await MainActor.run {
                    homeView.updateNotificationBadge(hasUnread: totalUnread > 0)
                }
            } catch {
                print("Failed to check notifications: \(error.localizedDescription)")
            }
        }
    }
        
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
        let leaderboardVC = LeaderboardViewController()
        navigationController?.pushViewController(leaderboardVC, animated: true)
    }
    
    @objc func onProfileTapped() {
        let profileVC = ProfileViewController()
        navigationController?.pushViewController(profileVC, animated: true)
    }
}

extension HomeScreenViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
        return 78
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let task = filteredTasks[indexPath.row]
        
        showTaskDetail(for: task)
    }

    private func showTaskDetail(for task: FitQuestTask) {
        let detailVC = TaskDetailViewController(task: task)
        
        detailVC.onTaskDeleted = { [weak self] in
            self?.loadDueTasks()
        }
        
        if let sheet = detailVC.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = false
            sheet.preferredCornerRadius = 20
        }
        
        present(detailVC, animated: true)
    }
            
    private func handleTaskCompletion(task: FitQuestTask, at indexPath: IndexPath) {
        guard let taskId = task.id, let userId = authService.currentUserId else { return }
        
        Task {
            do {
                // 1. Complete task (awards XP)
                try await taskService.completeTask(taskId: taskId)
                
                // 2. Update stats (no XP, just stats + level/tier)
                try await StatsService.shared.updateStatsAfterTaskCompletion(userId: userId, task: task)
                
                // 3. Clear notification read state
                NotificationStateManager.shared.clearReadStateForTask(userId: userId, taskId: taskId)
                
                // 4. Show success toast
                await MainActor.run {
                    self.showXPToast("+\(task.xpValue) XP", for: task)
                }
                
                // 5. Update UI (task will disappear from list)
                await MainActor.run {
                    if let cell = self.homeView.tasksTableView.cellForRow(at: indexPath) as? TaskTableViewCell {
                        cell.updateCompletionState(isCompleted: true, animated: true)
                    }
                    
                    self.loadDueTasks()
                    self.checkForUnreadNotifications()
                }
                
            } catch {
                await MainActor.run {
                    self.showAlert(title: "Error", message: "Failed to complete task")
                    
                    // Revert cell state
                    if let cell = self.homeView.tasksTableView.cellForRow(at: indexPath) as? TaskTableViewCell {
                        cell.updateCompletionState(isCompleted: false, animated: true)
                    }
                }
            }
        }
    }
    
    private func showXPToast(_ message: String, for task: FitQuestTask) {
        let toastContainer = UIView()
        toastContainer.backgroundColor = UIColor(red: 16/255, green: 185/255, blue: 129/255, alpha: 0.95)
        toastContainer.layer.cornerRadius = 12
        toastContainer.clipsToBounds = true
        toastContainer.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = task.title
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let xpLabel = UILabel()
        xpLabel.text = message
        xpLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        xpLabel.textColor = .white
        xpLabel.textAlignment = .center
        xpLabel.translatesAutoresizingMaskIntoConstraints = false
        
        toastContainer.addSubview(titleLabel)
        toastContainer.addSubview(xpLabel)
        view.addSubview(toastContainer)
        
        NSLayoutConstraint.activate([
            toastContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            toastContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            toastContainer.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 40),
            toastContainer.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -40),
            toastContainer.heightAnchor.constraint(equalToConstant: 70),
            
            titleLabel.topAnchor.constraint(equalTo: toastContainer.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: toastContainer.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: toastContainer.trailingAnchor, constant: -16),
            
            xpLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            xpLabel.leadingAnchor.constraint(equalTo: toastContainer.leadingAnchor, constant: 16),
            xpLabel.trailingAnchor.constraint(equalTo: toastContainer.trailingAnchor, constant: -16),
            xpLabel.bottomAnchor.constraint(equalTo: toastContainer.bottomAnchor, constant: -12)
        ])
        
        toastContainer.alpha = 0
        toastContainer.transform = CGAffineTransform(translationX: 0, y: 20)
        
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: [], animations: {
            toastContainer.alpha = 1
            toastContainer.transform = .identity
        }) { _ in
            // Animate out after 2 seconds
            UIView.animate(withDuration: 0.3, delay: 2.0, options: [], animations: {
                toastContainer.alpha = 0
                toastContainer.transform = CGAffineTransform(translationX: 0, y: 20)
            }) { _ in
                toastContainer.removeFromSuperview()
            }
        }
    }

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension HomeScreenViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
}
