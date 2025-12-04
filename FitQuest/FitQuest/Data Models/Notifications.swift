//
//  Notifications.swift
//  FitQuest
//
//  Created by Sunny Yadav on 12/2/25.
//

import Foundation
import FirebaseFirestore

// MARK: - Notification Type
enum NotificationType: String, Codable {
    case taskReminder = "task_reminder"
    case taskDue = "task_due"
    case streakReminder = "streak_reminder"
    case dailySummary = "daily_summary"
    case levelUp = "level_up"
    
    var icon: String {
        switch self {
        case .taskReminder, .taskDue: return "bell.fill"
        case .streakReminder: return "flame.fill"
        case .dailySummary: return "chart.bar.fill"
        case .levelUp: return "star.circle.fill"
        }
    }
    
    var color: UIColor {
        switch self {
        case .taskReminder, .taskDue: return UIColor(red: 0.33, green: 0.67, blue: 0.93, alpha: 1.0)
        case .streakReminder: return .systemOrange
        case .dailySummary: return .systemPurple
        case .levelUp: return .systemYellow
        }
    }
}

// MARK: - App Notification Model
struct AppNotification: Codable, Identifiable {
    var id: String?
    let userId: String
    let type: NotificationType
    let title: String
    let message: String
    let relatedTaskId: String? // Task ID if related to a task
    var isRead: Bool
    let createdAt: Date
    
    init(id: String? = nil, userId: String, type: NotificationType,
         title: String, message: String, relatedTaskId: String? = nil,
         isRead: Bool = false, createdAt: Date = Date()) {
        self.id = id
        self.userId = userId
        self.type = type
        self.title = title
        self.message = message
        self.relatedTaskId = relatedTaskId
        self.isRead = isRead
        self.createdAt = createdAt
    }
}
