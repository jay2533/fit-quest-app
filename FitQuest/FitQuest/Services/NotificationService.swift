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
