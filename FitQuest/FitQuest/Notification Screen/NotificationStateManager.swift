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
    
    private func getReadKey(userId: String, taskId: String) -> String {
        return "notification_read_\(userId)_\(taskId)"
    }
    
    func markTaskNotificationAsRead(userId: String, taskId: String) {
        let key = getReadKey(userId: userId, taskId: taskId)
        defaults.set(true, forKey: key)
    }
    
    func isTaskNotificationRead(userId: String, taskId: String) -> Bool {
        let key = getReadKey(userId: userId, taskId: taskId)
        return defaults.bool(forKey: key)
    }
    
    func markAllTaskNotificationsAsRead(userId: String, taskIds: [String]) {
        for taskId in taskIds {
            markTaskNotificationAsRead(userId: userId, taskId: taskId)
        }
    }
    
    func clearReadStateForTask(userId: String, taskId: String) {
        let key = getReadKey(userId: userId, taskId: taskId)
        defaults.removeObject(forKey: key)
    }
    
    func clearAllReadStates(userId: String) {
        let dictionary = defaults.dictionaryRepresentation()
        let prefix = "notification_read_\(userId)_"
        
        for key in dictionary.keys where key.hasPrefix(prefix) {
            defaults.removeObject(forKey: key)
        }
    }
}
