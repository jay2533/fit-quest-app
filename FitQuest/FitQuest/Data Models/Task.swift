//
//  Task.swift
//  FitQuest
//
//  Created by Sunny Yadav on 12/2/25.
//

import Foundation
import FirebaseFirestore

// MARK: - Task Category Enum
enum TaskCategory: String, Codable, CaseIterable {
    case physical = "Physical"
    case mental = "Mental"
    case social = "Social"

    var displayName: String {
        return rawValue
    }

    var icon: String {
        switch self {
        case .physical: return "figure.run"
        case .mental: return "brain.head.profile"
        case .social: return "person.3.fill"
        }
    }

    var colorHex: String {
        switch self {
        case .physical: return "#3B82F6" // Blue
        case .mental: return "#8B5CF6"   // Purple
        case .social: return "#10B981"   // Green
        }
    }
}

// MARK: - Task Model
struct FitQuestTask: Codable, Identifiable {
    var id: String?
    let userId: String
    let title: String
    let category: TaskCategory
    let isCustom: Bool
    let duration: Int // in minutes
    let scheduledDate: Date
    let scheduledTime: Date
    let notificationTime: Date
    let xpValue: Int
    var isCompleted: Bool
    var completedAt: Date?
    let notes: String?
    let imageURL: String?
    let createdAt: Date

    init(id: String? = nil, userId: String, title: String,
         category: TaskCategory, isCustom: Bool = true,
         duration: Int, scheduledDate: Date, scheduledTime: Date,
         notificationTime: Date, xpValue: Int,
         isCompleted: Bool = false, completedAt: Date? = nil,
         notes: String? = nil, imageURL: String? = nil,
         createdAt: Date = Date()) {
        self.id = id
        self.userId = userId
        self.title = title
        self.category = category
        self.isCustom = isCustom
        self.duration = duration
        self.scheduledDate = scheduledDate
        self.scheduledTime = scheduledTime
        self.notificationTime = notificationTime
        self.xpValue = xpValue
        self.isCompleted = isCompleted
        self.completedAt = completedAt
        self.notes = notes
        self.imageURL = imageURL
        self.createdAt = createdAt
    }
}

// MARK: - Predefined Task Model
struct PredefinedTask: Codable, Identifiable {
    var id: String?
    let title: String
    let description: String
    let category: TaskCategory
    let estimatedDuration: Int // in minutes
    let defaultXPValue: Int
    let iconName: String
    let difficulty: TaskDifficulty
    
    enum TaskDifficulty: String, Codable {
        case easy = "Easy"
        case medium = "Medium"
        case hard = "Hard"
        
        var xpMultiplier: Double {
            switch self {
            case .easy: return 1.0
            case .medium: return 1.5
            case .hard: return 2.0
            }
        }
    }
}
