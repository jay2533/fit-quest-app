//
//  NotificationService.swift
//  FitQuest
//
//  Created by Sunny Yadav on 12/4/25.
//

import Foundation
import FirebaseFirestore

class NotificationService {
    
    static let shared = NotificationService()
    private let database = Firestore.firestore()
    
    private init() {}
    
    // MARK: - Create Notification
    func createNotification(_ notification: AppNotification) async throws {
        let notificationData = try Firestore.Encoder().encode(notification)
        try await database.collection("notifications").addDocument(data: notificationData)
    }
    
    // MARK: - Fetch User Notifications
    func fetchUserNotifications(userId: String, limit: Int = 50) async throws -> [AppNotification] {
        let snapshot = try await database.collection("notifications")
            .whereField("userId", isEqualTo: userId)
            .order(by: "createdAt", descending: true)
            .limit(to: limit)
            .getDocuments()
        
        return snapshot.documents.compactMap { document in
            var notification = try? document.data(as: AppNotification.self)
            notification?.id = document.documentID
            return notification
        }
    }
    
    // MARK: - Fetch Unread Count
    func fetchUnreadCount(userId: String) async throws -> Int {
        let snapshot = try await database.collection("notifications")
            .whereField("userId", isEqualTo: userId)
            .whereField("isRead", isEqualTo: false)
            .getDocuments()
        
        return snapshot.documents.count
    }
    
    // MARK: - Mark Notification as Read
    func markAsRead(notificationId: String) async throws {
        try await database.collection("notifications")
            .document(notificationId)
            .updateData(["isRead": true])
    }
    
    // MARK: - Mark All as Read
    func markAllAsRead(userId: String) async throws {
        let snapshot = try await database.collection("notifications")
            .whereField("userId", isEqualTo: userId)
            .whereField("isRead", isEqualTo: false)
            .getDocuments()
        
        for document in snapshot.documents {
            try await document.reference.updateData(["isRead": true])
        }
    }
    
    // MARK: - Delete Notification
    func deleteNotification(notificationId: String) async throws {
        try await database.collection("notifications").document(notificationId).delete()
    }
    
    // MARK: - Fetch Total Unread Count (Including Generated Notifications)
    func fetchTotalUnreadCount(userId: String) async throws -> Int {
        // 1. Count stored notifications
        let storedUnread = try await fetchUnreadCount(userId: userId)
        
        // 2. Count task-based notifications
        let taskService = TaskService.shared
        let stateManager = NotificationStateManager.shared
        let activeTasks = try await taskService.fetchActiveTasks(userId: userId)
        
        let calendar = Calendar.current
        let now = Date()
        var taskNotificationCount = 0
        
        for task in activeTasks {
            guard let taskId = task.id else { continue }
            
            // 🔥 Skip if already marked as read
            if stateManager.isTaskNotificationRead(userId: userId, taskId: taskId) {
                continue
            }
            
            let taskDate = task.scheduledDate
            
            // Count: Overdue, Today, Tomorrow, This Week
            if taskDate < calendar.startOfDay(for: now) {
                taskNotificationCount += 1 // Overdue
            } else if calendar.isDateInToday(taskDate) {
                taskNotificationCount += 1 // Today
            } else if calendar.isDateInTomorrow(taskDate) {
                taskNotificationCount += 1 // Tomorrow
            } else if let daysUntil = calendar.dateComponents([.day], from: now, to: taskDate).day,
                      daysUntil >= 2 && daysUntil <= 7 {
                taskNotificationCount += 1 // This week
            }
        }
        
        return storedUnread + taskNotificationCount
    }
    
    // MARK: - Create Task Due Notifications
    func createTaskDueNotifications(userId: String, tasks: [FitQuestTask]) async throws {
        let calendar = Calendar.current
        let now = Date()
        
        for task in tasks where !task.isCompleted {
            // Check if task is due today or tomorrow
            if calendar.isDateInToday(task.scheduledDate) || calendar.isDateInTomorrow(task.scheduledDate) {
                let timeString = DateFormatter.timeOnly.string(from: task.scheduledTime)
                let dateString = calendar.isDateInToday(task.scheduledDate) ? "Today" : "Tomorrow"
                
                let notification = AppNotification(
                    userId: userId,
                    type: .taskDue,
                    title: "Task Due: \(task.title)",
                    message: "\(dateString) at \(timeString) - \(task.category.rawValue)",
                    relatedTaskId: task.id,
                    isRead: false,
                    createdAt: now
                )
                
                try await createNotification(notification)
            }
        }
    }
}
