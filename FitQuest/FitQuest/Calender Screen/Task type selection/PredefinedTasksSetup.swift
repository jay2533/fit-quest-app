//
//  PredefinedTasksSetup.swift
//  FitQuest
//
//  Created by Student on 12/4/25.
//

import Foundation
import FirebaseFirestore

class PredefinedTasksSetup {
    
    static let shared = PredefinedTasksSetup()
    private let database = Firestore.firestore()
    
    private init() {}
    
    // Call this once to populate predefined tasks
    func setupPredefinedTasks() async throws {
        let tasks = getAllPredefinedTasks()
        
        for task in tasks {
            let taskData = try Firestore.Encoder().encode(task)
            try await database.collection("predefinedTasks").addDocument(data: taskData)
        }
        
        print("✅ Successfully added \(tasks.count) predefined tasks to Firebase!")
    }
    
    private func getAllPredefinedTasks() -> [PredefinedTask] {
        var tasks: [PredefinedTask] = []
        
        // MARK: - Physical Tasks
        tasks.append(PredefinedTask(
            title: "Running",
            description: "Go for a run today",
            category: .physical,
            estimatedDuration: 60,
            defaultXPValue: 300,
            iconName: "figure.run",
            difficulty: .medium
        ))
        
        tasks.append(PredefinedTask(
            title: "Gym Workout",
            description: "Complete strength training session",
            category: .physical,
            estimatedDuration: 90,
            defaultXPValue: 450,
            iconName: "dumbbell.fill",
            difficulty: .hard
        ))
        
        tasks.append(PredefinedTask(
            title: "Yoga Session",
            description: "Mindful stretching and breathing",
            category: .physical,
            estimatedDuration: 45,
            defaultXPValue: 225,
            iconName: "figure.mind.and.body",
            difficulty: .easy
        ))
        
        // MARK: - Mental Tasks
        tasks.append(PredefinedTask(
            title: "Reading",
            description: "Read few pages from a book",
            category: .mental,
            estimatedDuration: 30,
            defaultXPValue: 150,
            iconName: "book.fill",
            difficulty: .easy
        ))
        
        tasks.append(PredefinedTask(
            title: "Meditation",
            description: "Calm your mind and focus",
            category: .mental,
            estimatedDuration: 20,
            defaultXPValue: 100,
            iconName: "sparkles",
            difficulty: .easy
        ))
        
        tasks.append(PredefinedTask(
            title: "Journaling",
            description: "Reflect on your day and thoughts",
            category: .mental,
            estimatedDuration: 15,
            defaultXPValue: 75,
            iconName: "note.text",
            difficulty: .easy
        ))
        
        // MARK: - Social Tasks
        tasks.append(PredefinedTask(
            title: "Coffee with Friend",
            description: "Quality time with someone you care about",
            category: .social,
            estimatedDuration: 60,
            defaultXPValue: 300,
            iconName: "cup.and.saucer.fill",
            difficulty: .easy
        ))
        
        tasks.append(PredefinedTask(
            title: "Phone Call Home",
            description: "Connect with family",
            category: .social,
            estimatedDuration: 30,
            defaultXPValue: 150,
            iconName: "phone.fill",
            difficulty: .easy
        ))
        
        tasks.append(PredefinedTask(
            title: "Networking Event",
            description: "Meet new people and expand connections",
            category: .social,
            estimatedDuration: 120,
            defaultXPValue: 600,
            iconName: "person.2.wave.2.fill",
            difficulty: .hard
        ))
        
        // MARK: - Creativity Tasks
        tasks.append(PredefinedTask(
            title: "Creative Writing",
            description: "Write stories, poems, or journal",
            category: .creativity,
            estimatedDuration: 45,
            defaultXPValue: 225,
            iconName: "pencil.and.outline",
            difficulty: .medium
        ))
        
        tasks.append(PredefinedTask(
            title: "Drawing/Painting",
            description: "Express yourself through art",
            category: .creativity,
            estimatedDuration: 60,
            defaultXPValue: 300,
            iconName: "paintbrush.fill",
            difficulty: .medium
        ))
        
        tasks.append(PredefinedTask(
            title: "Music Practice",
            description: "Practice your instrument",
            category: .creativity,
            estimatedDuration: 45,
            defaultXPValue: 225,
            iconName: "music.note",
            difficulty: .medium
        ))
        
        // MARK: - Miscellaneous Tasks
        tasks.append(PredefinedTask(
            title: "Organize Space",
            description: "Clean and declutter your environment",
            category: .miscellaneous,
            estimatedDuration: 30,
            defaultXPValue: 150,
            iconName: "tray.full.fill",
            difficulty: .easy
        ))
        
        tasks.append(PredefinedTask(
            title: "Meal Prep",
            description: "Prepare healthy meals",
            category: .miscellaneous,
            estimatedDuration: 60,
            defaultXPValue: 300,
            iconName: "fork.knife",
            difficulty: .medium
        ))
        
        tasks.append(PredefinedTask(
            title: "Budget Review",
            description: "Check finances and plan budget",
            category: .miscellaneous,
            estimatedDuration: 30,
            defaultXPValue: 150,
            iconName: "dollarsign.circle.fill",
            difficulty: .medium
        ))
        
        return tasks
    }
}
