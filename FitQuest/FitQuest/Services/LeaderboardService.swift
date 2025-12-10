//
//  LeaderboardService.swift
//  FitQuest
//
//  Created by Rushad Daruwalla on 12/9/25.
//

import Foundation
import FirebaseFirestore

struct LeaderboardEntry {
    let userId: String
    let name: String
    let totalXP: Int
    let profileImageURL: String?
    let rank: Int
}

class LeaderboardService {
    
    static let shared = LeaderboardService()
    private let database = Firestore.firestore()
    
    private init() {}
    
    // Fetch top N users by totalXP (for podium + table)
    func fetchTopUsers(limit: Int = 10) async throws -> [LeaderboardEntry] {
        let snapshot = try await database.collection("users")
            .order(by: "totalXP", descending: true)
            .limit(to: limit)
            .getDocuments()
        
        var entries: [LeaderboardEntry] = []
        var rank = 1
        
        for doc in snapshot.documents {
            let data = doc.data()
            let userId = doc.documentID
            let name = data["name"] as? String ?? "Player"
            let xp = data["totalXP"] as? Int ?? 0
            let profileImageURL = data["profileImageURL"] as? String
            
            let entry = LeaderboardEntry(
                userId: userId,
                name: name,
                totalXP: xp,
                profileImageURL: profileImageURL,
                rank: rank
            )
            entries.append(entry)
            rank += 1
        }
        
        return entries
    }
    
    // Compute current user's rank based on XP
    func fetchCurrentUserEntry(userId: String) async throws -> LeaderboardEntry {
        let userDoc = try await database.collection("users")
            .document(userId)
            .getDocument()
        
        guard let data = userDoc.data() else {
            throw NSError(domain: "LeaderboardService", code: -1,
                          userInfo: [NSLocalizedDescriptionKey: "User not found"])
        }
        
        let name = data["name"] as? String ?? "You"
        let xp = data["totalXP"] as? Int ?? 0
        let profileImageURL = data["profileImageURL"] as? String
        
        // Count how many users have strictly more XP
        let higherSnapshot = try await database.collection("users")
            .whereField("totalXP", isGreaterThan: xp)
            .getDocuments()
        
        let higherCount = higherSnapshot.documents.count
        let rank = higherCount + 1
        
        return LeaderboardEntry(
            userId: userId,
            name: name,
            totalXP: xp,
            profileImageURL: profileImageURL,
            rank: rank
        )
    }
    
    // Convenience combined fetch
    func fetchLeaderboard(userId: String, limit: Int = 10)
    async throws -> (top: [LeaderboardEntry], currentUser: LeaderboardEntry) {
        async let topUsersTask = fetchTopUsers(limit: limit)
        async let currentUserTask = fetchCurrentUserEntry(userId: userId)
        
        let (topUsers, currentUserEntry) = try await (topUsersTask, currentUserTask)
        return (topUsers, currentUserEntry)
    }
}
