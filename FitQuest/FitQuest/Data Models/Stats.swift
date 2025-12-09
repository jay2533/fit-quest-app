//
//  Stats.swift
//  FitQuest
//
//  Created by Sunny Yadav on 12/2/25.
//

import Foundation

// MARK: - Overall Stats Model
struct OverallStats: Codable {
    var totalTasksCompleted: Int
    var totalXPEarned: Int
    var currentStreak: Int
    var longestStreak: Int
    var lastUpdated: Date
    
    static var defaultStats: OverallStats {
        return OverallStats(
            totalTasksCompleted: 0,
            totalXPEarned: 0,
            currentStreak: 0,
            longestStreak: 0,
            lastUpdated: Date()
        )
    }
    
    init(totalTasksCompleted: Int = 0, totalXPEarned: Int = 0,
         currentStreak: Int = 0, longestStreak: Int = 0,
         lastUpdated: Date = Date()) {
        self.totalTasksCompleted = totalTasksCompleted
        self.totalXPEarned = totalXPEarned
        self.currentStreak = currentStreak
        self.longestStreak = longestStreak
        self.lastUpdated = lastUpdated
    }
}

// MARK: - Category Stats Model
struct CategoryStats: Codable {
    let category: TaskCategory
    var totalCompleted: Int
    var totalXPEarned: Int
    var currentStreak: Int
    var averageCompletionRate: Double
    
    init(category: TaskCategory, totalCompleted: Int = 0,
         totalXPEarned: Int = 0, currentStreak: Int = 0,
         averageCompletionRate: Double = 0.0) {
        self.category = category
        self.totalCompleted = totalCompleted
        self.totalXPEarned = totalXPEarned
        self.currentStreak = currentStreak
        self.averageCompletionRate = averageCompletionRate
    }
}

// MARK: - Daily Progress Model
struct DailyProgress: Codable, Identifiable {
    var id: String? // Date string "YYYY-MM-DD"
    let date: Date
    var physicalCompleted: Int
    var mentalCompleted: Int
    var socialCompleted: Int
    var totalXPEarned: Int
    var miscellaneousCompleted: Int
    var creativityCompleted: Int
    
    var totalCompleted: Int {
        return physicalCompleted + mentalCompleted + socialCompleted + miscellaneousCompleted + creativityCompleted
    }
    
    init(id: String? = nil, date: Date, physicalCompleted: Int = 0,
         mentalCompleted: Int = 0, socialCompleted: Int = 0,
         totalXPEarned: Int = 0, miscellaneousCompleted: Int = 0, creativityCompleted: Int = 0) {
        self.id = id
        self.date = date
        self.physicalCompleted = physicalCompleted
        self.mentalCompleted = mentalCompleted
        self.socialCompleted = socialCompleted
        self.totalXPEarned = totalXPEarned
        self.miscellaneousCompleted = miscellaneousCompleted
        self.creativityCompleted = creativityCompleted
    }
}

// MARK: - Weekly Stats Model
struct WeeklyStats {
    let weekStartDate: Date
    let weekEndDate: Date
    let dailyProgress: [DailyProgress]
    
    var totalTasksCompleted: Int {
        return dailyProgress.reduce(0) { $0 + $1.totalCompleted }
    }
    
    var totalXPEarned: Int {
        return dailyProgress.reduce(0) { $0 + $1.totalXPEarned }
    }
    
    var averageTasksPerDay: Double {
        guard !dailyProgress.isEmpty else { return 0 }
        return Double(totalTasksCompleted) / Double(dailyProgress.count)
    }
}

// MARK: - Category XP Model for Radar Chart
struct CategoryXP {
    let physical: Int
    let mental: Int
    let social: Int
    let creativity: Int
    let miscellaneous: Int
}
