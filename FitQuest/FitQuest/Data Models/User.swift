//
//  User.swift
//  FitQuest
//
//  Created by Sunny Yadav on 11/17/25.
//

import Foundation
import FirebaseFirestore

struct User: Codable {
    let userId: String
    let name: String
    let email: String
    let profileImageURL: String?
    let dateOfBirth: Date?
    let totalXP: Int
    let currentLevel: Int
    let currentTier: Int
    let createdAt: Date
    let lastActive: Date
    
    init(userId: String, name: String, email: String,
         profileImageURL: String? = nil, dateOfBirth: Date? = nil,
         totalXP: Int = 0, currentLevel: Int = 1, currentTier: Int = 1,
         createdAt: Date = Date(), lastActive: Date = Date()) {
        self.userId = userId
        self.name = name
        self.email = email
        self.profileImageURL = profileImageURL
        self.dateOfBirth = dateOfBirth
        self.totalXP = totalXP
        self.currentLevel = currentLevel
        self.currentTier = currentTier
        self.createdAt = createdAt
        self.lastActive = lastActive
    }
}

struct UserSettings: Codable {
    var notificationsEnabled: Bool
    var taskReminders: Bool
    var biometricAuthEnabled: Bool
    var profileVisibility: String
    
    static var defaultSettings: UserSettings {
        return UserSettings(
            notificationsEnabled: true,
            taskReminders: true,
            biometricAuthEnabled: false,
            profileVisibility: "public"
        )
    }
}

struct UserStats: Codable {
    var totalTasksCompleted: Int
    var totalXPEarned: Int
    var currentStreak: Int
    var longestStreak: Int
    var lastUpdated: Date
    
    static var defaultStats: UserStats {
        return UserStats(
            totalTasksCompleted: 0,
            totalXPEarned: 0,
            currentStreak: 0,
            longestStreak: 0,
            lastUpdated: Date()
        )
    }
}
