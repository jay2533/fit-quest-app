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
        
        drawerView.showDrawer()
    }
    
    private func setupActions() {
        drawerView.closeButton.addTarget(self, action: #selector(handleClose), for: .touchUpInside)
        drawerView.markAllReadButton.addTarget(self, action: #selector(handleMarkAllRead), for: .touchUpInside)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleBackgroundTap))
        drawerView.backgroundOverlay.addGestureRecognizer(tapGesture)
    }
    
    private func setupTableView() {
        drawerView.tableView.delegate = self
        drawerView.tableView.dataSource = self
    }
    
    private func loadNotifications() {
        guard let userId = authService.currentUserId else { return }
        
        Task {
            do {
                // Generate from tasks
                let generatedNotifications = try await generateNotificationsFromTasks(userId: userId)
                
                // Fetch stored notifications
                let storedNotifications = try await notificationService.fetchUserNotifications(userId: userId)
                
                // Combine both
                var allNotifications = storedNotifications + generatedNotifications
                
                // Sort by priority first, then by date
                allNotifications.sort { notification1, notification2 in
                    if notification1.type.priority != notification2.type.priority {
                        return notification1.type.priority < notification2.type.priority
                    }
                    return notification1.createdAt > notification2.createdAt
                }
                
                await MainActor.run {
                    self.notifications = allNotifications
                    self.updateEmptyState()
                    self.drawerView.tableView.reloadData()
                    
                    print(" Loaded \(allNotifications.count) total notifications")
                }
            } catch {
                print("Failed to load notifications: \(error.localizedDescription)")
            }
        }
    }
    
    // Generate Notifications from Active Tasks
    private func generateNotificationsFromTasks(userId: String) async throws -> [AppNotification] {
        let tasks = try await taskService.fetchActiveTasks(userId: userId)
        let stateManager = NotificationStateManager.shared
        
        var generatedNotifications: [AppNotification] = []
        let calendar = Calendar.current
        let now = Date()
        
        for task in tasks {
            guard let taskId = task.id else { continue }
            
            let taskDate = task.scheduledDate
            let timeString = DateFormatter.timeOnly.string(from: task.scheduledTime)
            
            // Check if this task's notification has been marked as read
            let isRead = stateManager.isTaskNotificationRead(userId: userId, taskId: taskId)
            
            // 1. OVERDUE TASKS
            if taskDate < calendar.startOfDay(for: now) {
                let daysOverdue = calendar.dateComponents([.day], from: taskDate, to: now).day ?? 0
                
                let notification = AppNotification(
                    id: "task_overdue_\(taskId)",
                    userId: userId,
                    type: .taskReminder,
                    title: "Overdue: \(task.title)",
                    message: "\(daysOverdue) day(s) overdue - \(task.category.rawValue) category",
                    relatedTaskId: taskId,
                    isRead: isRead,
                    createdAt: task.scheduledDate
                )
                
                generatedNotifications.append(notification)
            }
            // 2. DUE TODAY
            else if calendar.isDateInToday(taskDate) {
                let notification = AppNotification(
                    id: "task_today_\(taskId)",
                    userId: userId,
                    type: .taskDue,
                    title: " Due Today: \(task.title)",
                    message: "Scheduled for \(timeString) - \(task.category.rawValue) category",
                    relatedTaskId: taskId,
                    isRead: isRead,
                    createdAt: task.scheduledDate
                )
                
                generatedNotifications.append(notification)
            }
            // 3. DUE TOMORROW
            else if calendar.isDateInTomorrow(taskDate) {
                let notification = AppNotification(
                    id: "task_tomorrow_\(taskId)",
                    userId: userId,
                    type: .taskReminder,
                    title: "Tomorrow: \(task.title)",
                    message: "Scheduled for \(timeString) - \(task.category.rawValue) category",
                    relatedTaskId: taskId,
                    isRead: isRead,
                    createdAt: task.scheduledDate
                )
                
                generatedNotifications.append(notification)
            }
            // 4. UPCOMING THIS WEEK
            else if let daysUntil = calendar.dateComponents([.day], from: now, to: taskDate).day,
                    daysUntil >= 2 && daysUntil <= 7 {
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "EEE, MMM d"
                let dateString = dateFormatter.string(from: taskDate)
                
                let notification = AppNotification(
                    id: "task_week_\(taskId)",
                    userId: userId,
                    type: .taskReminder,
                    title: "Upcoming: \(task.title)",
                    message: "\(dateString) at \(timeString) - \(task.category.rawValue) category",
                    relatedTaskId: taskId,
                    isRead: isRead,
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
        guard let userId = authService.currentUserId else { return }
        
        // Mark all as read locally
        for index in notifications.indices {
            var notification = notifications[index]
            
            if !notification.isRead {
                notification.isRead = true
                notifications[index] = notification
                
                // Persist read state for task notifications
                if let taskId = notification.relatedTaskId {
                    NotificationStateManager.shared.markTaskNotificationAsRead(userId: userId, taskId: taskId)
                }
            }
        }
        
        // Also mark stored notifications as read in Firestore
        Task {
            try? await notificationService.markAllAsRead(userId: userId)
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
        var notification = notifications[indexPath.row]
        
        // Mark as read if it was unread
        if !notification.isRead {
            notification.isRead = true
            notifications[indexPath.row] = notification
            
            // If it's a task notification, persist the read state
            if let taskId = notification.relatedTaskId,
               let userId = authService.currentUserId {
                NotificationStateManager.shared.markTaskNotificationAsRead(userId: userId, taskId: taskId)
            }
            
            // If it's a stored notification, update in Firestore
            if let notificationId = notification.id, !notificationId.hasPrefix("task_") {
                Task {
                    try? await notificationService.markAsRead(notificationId: notificationId)
                }
            }
            
            tableView.reloadRows(at: [indexPath], with: .automatic)
            onDismiss?() // Update badge
        }
        
        if let taskId = notification.relatedTaskId {
            print("Navigate to task: \(taskId)")
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
