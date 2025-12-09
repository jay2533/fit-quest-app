//
//  FirestoreService.swift
//  FitQuest
//
//  Created by Sunny Yadav on 12/2/25.
//

import Foundation
import FirebaseFirestore

class FirestoreService {
    
    static let shared = FirestoreService()
    private let database = Firestore.firestore()
    
    private init() {}
    
    // MARK: - Save User Profile
    func saveUserProfile(userId: String, name: String, email: String,
                        dateOfBirth: Date?, photoURL: URL?) async throws {
        var userData: [String: Any] = [
            "name": name,
            "email": email,
            "profileImageURL": photoURL?.absoluteString ?? "",
            "totalXP": 0,
            "currentLevel": 1,
            "currentTier": 1,
            "createdAt": FieldValue.serverTimestamp(),
            "lastActive": FieldValue.serverTimestamp()
        ]
        
        if let dob = dateOfBirth {
            userData["dateOfBirth"] = Timestamp(date: dob)
        }
        
        try await database.collection("users").document(userId).setData(userData)
    }
    
    // MARK: - Create Default Settings
    func createDefaultSettings(userId: String) async throws {
        let settings = UserSettings.defaultSettings
        let settingsData = try Firestore.Encoder().encode(settings)
        
        try await database.collection("users")
            .document(userId)
            .collection("settings")
            .document("preferences")
            .setData(settingsData)
    }
    
    // MARK: - Create Default Stats
    func createDefaultStats(userId: String) async throws {
        // Overall stats
        let overallStats = UserStats.defaultStats
        let overallData = try Firestore.Encoder().encode(overallStats)
        
        try await database.collection("stats")
            .document(userId)
            .collection("overall")
            .document("summary")
            .setData(overallData)
        
        // Category stats — use ALL TaskCategory cases
        for category in TaskCategory.allCases {
            let categoryData: [String: Any] = [
                "category": category.rawValue,
                "totalCompleted": 0,
                "totalXPEarned": 0,
                "currentStreak": 0,
                "averageCompletionRate": 0.0
            ]
            
            try await database.collection("stats")
                .document(userId)
                .collection("categoryStats")
                .document(category.rawValue)
                .setData(categoryData)
        }
    }

    
    // MARK: - Fetch User Profile
    func fetchUserProfile(userId: String) async throws -> User {
        let document = try await database.collection("users").document(userId).getDocument()
        
        guard let data = document.data() else {
            throw NSError(domain: "FirestoreService", code: -1,
                         userInfo: [NSLocalizedDescriptionKey: "User profile not found"])
        }
        
        return try Firestore.Decoder().decode(User.self, from: data)
    }
}
