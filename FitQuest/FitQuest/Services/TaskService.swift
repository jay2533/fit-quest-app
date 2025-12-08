//
//  TaskService.swift
//  FitQuest
//
//  Created by Sunny Yadav on 12/2/25.
//

import Foundation
import FirebaseFirestore

class TaskService {
    
    static let shared = TaskService()
    private let database = Firestore.firestore()
    
    private init() {}
    
    // MARK: - Create Task
    func createTask(_ task: FitQuestTask) async throws -> String {
        let taskData = try Firestore.Encoder().encode(task)
        let docRef = try await database.collection(Constants.Collections.tasks).addDocument(data: taskData)
        return docRef.documentID
    }
    
    // MARK: - Fetch User's Active Tasks
    func fetchActiveTasks(userId: String) async throws -> [FitQuestTask] {
        let snapshot = try await database.collection(Constants.Collections.tasks)
            .whereField("userId", isEqualTo: userId)
            .whereField("isCompleted", isEqualTo: false)
            .order(by: "scheduledDate")
            .getDocuments()
        
        return snapshot.documents.compactMap { document in
            var task = try? document.data(as: FitQuestTask.self)
            task?.id = document.documentID
            return task
        }
    }
    
    // MARK: - Fetch User's Completed Tasks
    func fetchCompletedTasks(userId: String, limit: Int = 20) async throws -> [FitQuestTask] {
        let snapshot = try await database.collection(Constants.Collections.tasks)
            .whereField("userId", isEqualTo: userId)
            .whereField("isCompleted", isEqualTo: true)
            .order(by: "completedAt", descending: true)
            .limit(to: limit)
            .getDocuments()
        
        return snapshot.documents.compactMap { document in
            var task = try? document.data(as: FitQuestTask.self)
            task?.id = document.documentID
            return task
        }
    }
    
    // MARK: - Fetch Tasks by Category
    func fetchTasksByCategory(userId: String, category: TaskCategory) async throws -> [FitQuestTask] {
        let snapshot = try await database.collection(Constants.Collections.tasks)
            .whereField("userId", isEqualTo: userId)
            .whereField("category", isEqualTo: category.rawValue)
            .whereField("isCompleted", isEqualTo: false)
            .order(by: "scheduledDate")
            .getDocuments()
        
        return snapshot.documents.compactMap { document in
            var task = try? document.data(as: FitQuestTask.self)
            task?.id = document.documentID
            return task
        }
    }
    
    // MARK: - ✅ UPDATED: Complete Task (Now with XP Award)
    func completeTask(taskId: String) async throws {
        // 1. Fetch the task to get xpValue and userId
        let task = try await fetchTask(taskId: taskId)
        
        // 2. Update task in Firestore
        try await database.collection(Constants.Collections.tasks).document(taskId).updateData([
            "isCompleted": true,
            "completedAt": FieldValue.serverTimestamp()
        ])
        
        print("✅ Task \(taskId) marked complete")
        
        // 3. Award XP to user
        try await awardXP(userId: task.userId, xp: task.xpValue)
        
        print("💰 Awarded \(task.xpValue) XP to user \(task.userId)")
    }
    
    // MARK: - ✅ NEW: Unmark Task (with 5-minute grace period)
    func unmarkTask(taskId: String) async throws {
        // 1. Fetch task to check completedAt and get xpValue
        let task = try await fetchTask(taskId: taskId)
        
        // 2. Check if within 5-minute window
        guard canUnmarkTask(task) else {
            throw NSError(
                domain: "TaskService",
                code: -2,
                userInfo: [NSLocalizedDescriptionKey: "Cannot undo completion after 5 minutes"]
            )
        }
        
        // 3. Update task in Firestore
        try await database.collection(Constants.Collections.tasks).document(taskId).updateData([
            "isCompleted": false,
            "completedAt": FieldValue.delete()
        ])
        
        print("⭕️ Task \(taskId) unmarked")
        
        // 4. Deduct XP from user
        try await deductXP(userId: task.userId, xp: task.xpValue)
        
        print("💸 Deducted \(task.xpValue) XP from user \(task.userId)")
    }
    
    // MARK: - ✅ NEW: Check if Task Can Be Unmarked
    func canUnmarkTask(_ task: FitQuestTask) -> Bool {
        guard let completedAt = task.completedAt else {
            return false // Not completed, can't unmark
        }
        
        let now = Date()
        let timeSinceCompletion = now.timeIntervalSince(completedAt)
        let fiveMinutesInSeconds: TimeInterval = 5 * 60 // 300 seconds
        
        return timeSinceCompletion <= fiveMinutesInSeconds
    }
    
    // MARK: - ✅ NEW: Private XP Helpers
    private func awardXP(userId: String, xp: Int) async throws {
        let userRef = database.collection(Constants.Collections.users).document(userId)
        
        try await userRef.updateData([
            "totalXP": FieldValue.increment(Int64(xp))
        ])
    }
    
    private func deductXP(userId: String, xp: Int) async throws {
        let userRef = database.collection(Constants.Collections.users).document(userId)
        
        try await userRef.updateData([
            "totalXP": FieldValue.increment(Int64(-xp))
        ])
    }
    
    // MARK: - Delete Task
    func deleteTask(taskId: String) async throws {
        try await database.collection(Constants.Collections.tasks).document(taskId).delete()
    }
    
    // MARK: - Fetch Predefined Tasks
    func fetchPredefinedTasks(category: TaskCategory? = nil) async throws -> [PredefinedTask] {
        var query: Query = database.collection(Constants.Collections.predefinedTasks)
        
        if let category = category {
            query = query.whereField("category", isEqualTo: category.rawValue)
        }
        
        let snapshot = try await query.getDocuments()
        
        return snapshot.documents.compactMap { document in
            var task = try? document.data(as: PredefinedTask.self)
            task?.id = document.documentID
            return task
        }
    }
    
    // MARK: - Update Task
    func updateTask(taskId: String, updates: [String: Any]) async throws {
        try await database.collection(Constants.Collections.tasks).document(taskId).updateData(updates)
    }
    
    // MARK: - Fetch Task by ID
    func fetchTask(taskId: String) async throws -> FitQuestTask {
        let document = try await database.collection(Constants.Collections.tasks).document(taskId).getDocument()
        
        guard var task = try? document.data(as: FitQuestTask.self) else {
            throw NSError(domain: "TaskService", code: -1,
                         userInfo: [NSLocalizedDescriptionKey: "Task not found"])
        }
        
        task.id = document.documentID
        return task
    }
}
