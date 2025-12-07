//
//  NotificationStateManager.swift
//  FitQuest
//
//  Created by Sunny Yadav on 12/7/25.
//

import Foundation

class NotificationStateManager {
    
    static let shared = NotificationStateManager()
    private let defaults = UserDefaults.standard
    
    private init() {}
    
    // Key format: "notification_read_{userId}_{taskId}"
    private func getReadKey(userId: String, taskId: String) -> String {
        return "notification_read_\(userId)_\(taskId)"
    }
    
    // MARK: - Mark Task Notification as Read
    func markTaskNotificationAsRead(userId: String, taskId: String) {
        let key = getReadKey(userId: userId, taskId: taskId)
        defaults.set(true, forKey: key)
    }
    
    // MARK: - Check if Task Notification is Read
    func isTaskNotificationRead(userId: String, taskId: String) -> Bool {
        let key = getReadKey(userId: userId, taskId: taskId)
        return defaults.bool(forKey: key)
    }
    
    // MARK: - Mark All Task Notifications as Read
    func markAllTaskNotificationsAsRead(userId: String, taskIds: [String]) {
        for taskId in taskIds {
            markTaskNotificationAsRead(userId: userId, taskId: taskId)
        }
    }
    
    // MARK: - Clear Read State for Completed Task
    func clearReadStateForTask(userId: String, taskId: String) {
        let key = getReadKey(userId: userId, taskId: taskId)
        defaults.removeObject(forKey: key)
    }
    
    // MARK: - Clear All Read States (for logout/testing)
    func clearAllReadStates(userId: String) {
        let dictionary = defaults.dictionaryRepresentation()
        let prefix = "notification_read_\(userId)_"
        
        for key in dictionary.keys where key.hasPrefix(prefix) {
            defaults.removeObject(forKey: key)
        }
    }
}
