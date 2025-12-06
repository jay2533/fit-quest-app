//
//  StatsService.swift
//  FitQuest
//
//  Created by Sunny Yadav on 12/2/25.
//


import Foundation
import FirebaseFirestore

class StatsService {
    
    static let shared = StatsService()
    private let database = Firestore.firestore()
    
    private init() {}
    
    // MARK: - Update Stats After Task Completion
    func updateStatsAfterTaskCompletion(userId: String, task: FitQuestTask) async throws {
        // Update overall stats
        try await updateOverallStats(userId: userId, xpEarned: task.xpValue)
        
        // Update category stats
        try await updateCategoryStats(userId: userId, category: task.category, xpEarned: task.xpValue)
        
        // Update daily progress
        try await updateDailyProgress(userId: userId, category: task.category, xpEarned: task.xpValue)
        
        // Update user XP
        try await updateUserXP(userId: userId, xpEarned: task.xpValue)
        
        // Update streak
        try await updateStreak(userId: userId)
    }
    
    // MARK: - Update Overall Stats
    private func updateOverallStats(userId: String, xpEarned: Int) async throws {
        let statsRef = database.collection("stats")
            .document(userId)
            .collection("overall")
            .document("summary")
        
        try await statsRef.updateData([
            "totalTasksCompleted": FieldValue.increment(Int64(1)),
            "totalXPEarned": FieldValue.increment(Int64(xpEarned)),
            "lastUpdated": FieldValue.serverTimestamp()
        ])
    }
    
    // MARK: - Update Category Stats
    private func updateCategoryStats(userId: String, category: TaskCategory, xpEarned: Int) async throws {
        let categoryRef = database.collection("stats")
            .document(userId)
            .collection("categoryStats")
            .document(category.rawValue)
        
        try await categoryRef.updateData([
            "totalCompleted": FieldValue.increment(Int64(1)),
            "totalXPEarned": FieldValue.increment(Int64(xpEarned))
        ])
    }
    
    // MARK: - Update Daily Progress
    private func updateDailyProgress(userId: String, category: TaskCategory, xpEarned: Int) async throws {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: Date())
        
        let progressRef = database.collection("stats")
            .document(userId)
            .collection("progressTrends")
            .document(dateString)
        
        let fieldName: String
        switch category {
        case .physical:
            fieldName = "physicalCompleted"
        case .mental:
            fieldName = "mentalCompleted"
        case .social:
            fieldName = "socialCompleted"
        case .creativity:
            fieldName = "creativeCompleted"
        case .miscellaneous:
            fieldName = "miscellaneousCompleted"
        }
        
        // Check if document exists
        let document = try await progressRef.getDocument()
        
        if document.exists {
            try await progressRef.updateData([
                fieldName: FieldValue.increment(Int64(1)),
                "totalXPEarned": FieldValue.increment(Int64(xpEarned))
            ])
        } else {
            // Create new document
            var data: [String: Any] = [
                "date": Timestamp(date: Date()),
                "physicalCompleted": 0,
                "mentalCompleted": 0,
                "socialCompleted": 0,
                "totalXPEarned": xpEarned
            ]
            data[fieldName] = 1
            
            try await progressRef.setData(data)
        }
    }
    
    // MARK: - Update User XP
    private func updateUserXP(userId: String, xpEarned: Int) async throws {
        let userRef = database.collection("users").document(userId)
        
        // Get current XP to calculate level
        let document = try await userRef.getDocument()
        guard let currentXP = document.data()?["totalXP"] as? Int else { return }
        
        let newXP = currentXP + xpEarned
        let newLevel = Constants.Levels.getLevel(xp: newXP)
        let newTier = Constants.Levels.getTier(xp: newXP)
        
        try await userRef.updateData([
            "totalXP": newXP,
            "currentLevel": newLevel,
            "currentTier": newTier,
            "lastActive": FieldValue.serverTimestamp()
        ])
    }
    
    // MARK: - Update Streak
    private func updateStreak(userId: String) async throws {
        let statsRef = database.collection("stats")
            .document(userId)
            .collection("overall")
            .document("summary")
        
        let document = try await statsRef.getDocument()
        guard let data = document.data(),
              let currentStreak = data["currentStreak"] as? Int,
              let lastUpdatedTimestamp = data["lastUpdated"] as? Timestamp else {
            return
        }
        
        let lastUpdated = lastUpdatedTimestamp.dateValue()
        let calendar = Calendar.current
        
        // Check if last update was yesterday
        if calendar.isDateInYesterday(lastUpdated) {
            // Continue streak
            let newStreak = currentStreak + 1
            let longestStreak = max(newStreak, data["longestStreak"] as? Int ?? 0)
            
            try await statsRef.updateData([
                "currentStreak": newStreak,
                "longestStreak": longestStreak
            ])
        } else if !calendar.isDateInToday(lastUpdated) {
            // Streak broken, reset to 1
            try await statsRef.updateData([
                "currentStreak": 1
            ])
        }
        // If today, streak stays the same
    }
    
    // MARK: - Fetch Overall Stats
    func fetchOverallStats(userId: String) async throws -> OverallStats {
        let document = try await database.collection("stats")
            .document(userId)
            .collection("overall")
            .document("summary")
            .getDocument()
        
        return try document.data(as: OverallStats.self)
    }
    
    // MARK: - Fetch Category Stats
    func fetchCategoryStats(userId: String) async throws -> [CategoryStats] {
        let snapshot = try await database.collection("stats")
            .document(userId)
            .collection("categoryStats")
            .getDocuments()
        
        return snapshot.documents.compactMap { document in
            try? document.data(as: CategoryStats.self)
        }
    }
    
    // MARK: - Fetch Daily Progress
    func fetchDailyProgress(userId: String, startDate: Date, endDate: Date) async throws -> [DailyProgress] {
        let snapshot = try await database.collection("stats")
            .document(userId)
            .collection("progressTrends")
            .whereField("date", isGreaterThanOrEqualTo: Timestamp(date: startDate))
            .whereField("date", isLessThanOrEqualTo: Timestamp(date: endDate))
            .order(by: "date")
            .getDocuments()
        
        return snapshot.documents.compactMap { document in
            var progress = try? document.data(as: DailyProgress.self)
            progress?.id = document.documentID
            return progress
        }
    }
    
    // MARK: - Fetch Weekly Progress
    func fetchWeeklyProgress(userId: String) async throws -> [DailyProgress] {
        let calendar = Calendar.current
        let today = Date()
        let weekAgo = calendar.date(byAdding: .day, value: -7, to: today) ?? today
        
        return try await fetchDailyProgress(userId: userId, startDate: weekAgo, endDate: today)
    }
    
    // MARK: - Fetch Monthly Progress
    func fetchMonthlyProgress(userId: String) async throws -> [DailyProgress] {
        let calendar = Calendar.current
        let today = Date()
        let monthAgo = calendar.date(byAdding: .month, value: -1, to: today) ?? today
        
        return try await fetchDailyProgress(userId: userId, startDate: monthAgo, endDate: today)
    }
}
