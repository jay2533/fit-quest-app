//
//  NotificationDrawerViewController.swift
//  FitQuest
//
//  Created by Sunny Yadav on 12/2/25.
//

import UIKit

class NotificationDrawerViewController: UIViewController {
    
    private let drawerView = NotificationDrawerView()
    private let notificationService = NotificationService.shared
    private let taskService = TaskService.shared
    private let authService = AuthService.shared
    
    private var notifications: [AppNotification] = []
    var onDismiss: (() -> Void)?
    
    override func loadView() {
        view = drawerView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupActions()
        setupTableView()
        loadNotifications()
        
        // Show drawer with animation
        drawerView.showDrawer()
    }
    
    private func setupActions() {
        drawerView.closeButton.addTarget(self, action: #selector(handleClose), for: .touchUpInside)
        drawerView.markAllReadButton.addTarget(self, action: #selector(handleMarkAllRead), for: .touchUpInside)
        
        // Tap background to dismiss
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleBackgroundTap))
        drawerView.backgroundOverlay.addGestureRecognizer(tapGesture)
    }
    
    private func setupTableView() {
        drawerView.tableView.delegate = self
        drawerView.tableView.dataSource = self
    }
    
    // MARK: - Load Notifications
    private func loadNotifications() {
        guard let userId = authService.currentUserId else { return }
        
        Task {
            do {
                // 🔥 Method 1: Generate from tasks (no database storage)
                let generatedNotifications = try await generateNotificationsFromTasks(userId: userId)
                
                // 🔥 Method 2: Fetch from database (if you're storing them)
                let storedNotifications = try await notificationService.fetchUserNotifications(userId: userId)
                
                // Combine both (stored notifications + generated task notifications)
                let allNotifications = storedNotifications + generatedNotifications
                
                // Sort by date (newest first)
                let sortedNotifications = allNotifications.sorted { $0.createdAt > $1.createdAt }
                
                await MainActor.run {
                    self.notifications = sortedNotifications
                    self.updateEmptyState()
                    self.drawerView.tableView.reloadData()
                }
            } catch {
                print("Failed to load notifications: \(error.localizedDescription)")
            }
        }
    }
    
    // 🔥 Generate Notifications from Active Tasks
    private func generateNotificationsFromTasks(userId: String) async throws -> [AppNotification] {
        // Fetch active tasks
        let tasks = try await taskService.fetchActiveTasks(userId: userId)
        
        var generatedNotifications: [AppNotification] = []
        let calendar = Calendar.current
        let now = Date()
        
        for task in tasks {
            // Check if task is due today
            if calendar.isDateInToday(task.scheduledDate) {
                let timeString = DateFormatter.timeOnly.string(from: task.scheduledTime)
                
                let notification = AppNotification(
                    id: "task_\(task.id ?? UUID().uuidString)", // Temporary ID
                    userId: userId,
                    type: .taskDue,
                    title: "Due Today: \(task.title)",
                    message: "Scheduled for \(timeString) - \(task.category.rawValue) category",
                    relatedTaskId: task.id,
                    isRead: false,
                    createdAt: task.scheduledDate
                )
                
                generatedNotifications.append(notification)
            }
            // Check if task is due tomorrow
            else if calendar.isDateInTomorrow(task.scheduledDate) {
                let timeString = DateFormatter.timeOnly.string(from: task.scheduledTime)
                
                let notification = AppNotification(
                    id: "task_\(task.id ?? UUID().uuidString)",
                    userId: userId,
                    type: .taskReminder,
                    title: "Tomorrow: \(task.title)",
                    message: "Scheduled for \(timeString) - \(task.category.rawValue) category",
                    relatedTaskId: task.id,
                    isRead: false,
                    createdAt: task.scheduledDate
                )
                
                generatedNotifications.append(notification)
            }
            // Check if task is overdue
            else if task.scheduledDate < now {
                let notification = AppNotification(
                    id: "task_\(task.id ?? UUID().uuidString)",
                    userId: userId,
                    type: .taskReminder,
                    title: "⚠️ Overdue: \(task.title)",
                    message: "This task is overdue - \(task.category.rawValue) category",
                    relatedTaskId: task.id,
                    isRead: false,
                    createdAt: task.scheduledDate
                )
                
                generatedNotifications.append(notification)
            }
        }
        
        return generatedNotifications
    }
    
    private func updateEmptyState() {
        drawerView.emptyStateLabel.isHidden = !notifications.isEmpty
        drawerView.markAllReadButton.isHidden = notifications.isEmpty
    }
    
    @objc private func handleClose() {
        dismissDrawer()
    }
    
    @objc private func handleBackgroundTap() {
        dismissDrawer()
    }
    
    @objc private func handleMarkAllRead() {
        // Mark all as read locally
        for index in notifications.indices {
            notifications[index].isRead = true
        }
        
        drawerView.tableView.reloadData()
        onDismiss?() // Update badge
    }
    
    private func dismissDrawer() {
        drawerView.hideDrawer { [weak self] in
            self?.dismiss(animated: false) {
                self?.onDismiss?()
            }
        }
    }
}

// MARK: - UITableViewDelegate & DataSource
extension NotificationDrawerViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: NotificationCell.identifier,
            for: indexPath
        ) as? NotificationCell else {
            return UITableViewCell()
        }
        
        let notification = notifications[indexPath.row]
        cell.configure(with: notification)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let notification = notifications[indexPath.row]
        
        // Mark as read
        if !notification.isRead {
            notifications[indexPath.row].isRead = true
            tableView.reloadRows(at: [indexPath], with: .automatic)
            onDismiss?()
        }
        
        // TODO: Navigate to related task
        if let taskId = notification.relatedTaskId {
            // dismissDrawer()
            // Navigate to task detail screen
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            notifications.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            updateEmptyState()
            onDismiss?()
        }
    }
}
