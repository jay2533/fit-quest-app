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
    // MARK: - Create Task
    func createTask(_ task: FitQuestTask) async throws -> String {
        // Save task to Firestore
        let taskData = try Firestore.Encoder().encode(task)
        let docRef = try await database.collection("tasks").addDocument(data: taskData)
        let taskId = docRef.documentID
        
        return taskId
    }

    
    
    // MARK: - Fetch User's Active Tasks
    func fetchActiveTasks(userId: String) async throws -> [FitQuestTask] {
        let snapshot = try await database.collection("tasks")
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
        let snapshot = try await database.collection("tasks")
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
        let snapshot = try await database.collection("tasks")
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
    
    // MARK: - Complete Task
    func completeTask(taskId: String) async throws {
        try await database.collection("tasks").document(taskId).updateData([
            "isCompleted": true,
            "completedAt": FieldValue.serverTimestamp()
        ])
    }
    
    // MARK: - Delete Task
    func deleteTask(taskId: String) async throws {
        try await database.collection("tasks").document(taskId).delete()
    }
    
    // MARK: - Fetch Predefined Tasks
    func fetchPredefinedTasks(category: TaskCategory? = nil) async throws -> [PredefinedTask] {
        var query: Query = database.collection("predefinedTasks")
        
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
        try await database.collection("tasks").document(taskId).updateData(updates)
    }
    
    // MARK: - Fetch Task by ID
    func fetchTask(taskId: String) async throws -> FitQuestTask {
        let document = try await database.collection("tasks").document(taskId).getDocument()
        
        guard var task = try? document.data(as: FitQuestTask.self) else {
            throw NSError(domain: "TaskService", code: -1,
                         userInfo: [NSLocalizedDescriptionKey: "Task not found"])
        }
        
        task.id = document.documentID
        return task
    }
}
