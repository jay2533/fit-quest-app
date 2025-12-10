//
//  Constants.swift
//  FitQuest
//
//  Created by Sunny Yadav on 12/2/25.
//


import Foundation

struct Constants {
    
    struct Collections {
        static let users = "users"
        static let tasks = "tasks"
        static let predefinedTasks = "predefinedTasks"
        static let stats = "stats"
        static let notifications = "notifications"
    }
    
    struct XP {
        static let baseXP = 50
        static let easyMultiplier = 1.0
        static let mediumMultiplier = 1.5
        static let hardMultiplier = 2.0
        static let completionBonus = 10
        
        static func calculateXP(duration: Int, difficulty: PredefinedTask.TaskDifficulty) -> Int {
            let baseValue = (duration / 10) * baseXP // 50 XP per 10 minutes
            let multiplier = difficulty.xpMultiplier
            return Int(Double(baseValue) * multiplier) + completionBonus
        }
    }
    
    struct Levels {
        static let tier1Threshold = 0
        static let tier2Threshold = 5000
        static let tier3Threshold = 10000
        
        static func getTier(xp: Int) -> Int {
            if xp >= tier3Threshold {
                return 3
            } else if xp >= tier2Threshold {
                return 2
            } else {
                return 1
            }
        }
        
        static func getLevel(xp: Int) -> Int {
            return max(1, xp / 250)
        }
        
        static func xpForNextLevel(currentXP: Int) -> Int {
            let currentLevel = getLevel(xp: currentXP)
            let nextLevelXP = (currentLevel + 1) * 250
            return nextLevelXP - currentXP
        }
    }
    
    struct Defaults {
        static let profileImagePlaceholder = "person.circle.fill"
        static let defaultTaskDuration = 30 // minutes
        static let minTaskDuration = 5 // minutes
        static let maxTaskDuration = 240 // minutes (4 hours)
    }
    
    struct NotificationIdentifiers {
        static let taskReminderPrefix = "task_reminder_"
        static let streakReminderPrefix = "streak_reminder_"
        static let dailySummary = "daily_summary"
    }
    
    struct API {
            static let diceBearBaseURL = "https://api.dicebear.com/7.x"
            static let avatarStyle = "avataaars"
            
            static func getAvatarURL(name: String, size: Int = 120) -> String {
                let encodedName = name.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "user"
                return "\(diceBearBaseURL)/\(avatarStyle)/png?seed=\(encodedName)&size=\(size)"
            }
        }
}
