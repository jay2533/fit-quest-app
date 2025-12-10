//
//  Notifications.swift
//  FitQuest
//
//  Created by Sunny Yadav on 12/2/25.
//

import Foundation
import FirebaseFirestore

enum NotificationType: String, Codable {
    case taskReminder = "task_reminder"
    case taskDue = "task_due"
    case streakReminder = "streak_reminder"
    case dailySummary = "daily_summary"
    case levelUp = "level_up"
    
    var icon: String {
        switch self {
        case .taskReminder: return "clock.fill"
        case .taskDue: return "bell.badge.fill"
        case .streakReminder: return "flame.fill"
        case .dailySummary: return "chart.bar.fill"
        case .levelUp: return "star.circle.fill"
        }
    }

    var color: UIColor {
        switch self {
        case .taskReminder: return UIColor(red: 0.33, green: 0.67, blue: 0.93, alpha: 1.0)
        case .taskDue: return UIColor.systemOrange
        case .streakReminder: return UIColor.systemRed
        case .dailySummary: return UIColor.systemPurple
        case .levelUp: return UIColor.systemYellow
        }
    }

    var priority: Int {
        switch self {
        case .taskDue: return 1 // Highest priority (due today)
        case .taskReminder: return 2 // Medium (upcoming)
        case .levelUp: return 3
        case .streakReminder: return 4
        case .dailySummary: return 5 // Lowest priority
        }
    }
}

struct AppNotification: Codable, Identifiable {
    var id: String?
    let userId: String
    let type: NotificationType
    let title: String
    let message: String
    let relatedTaskId: String?
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
