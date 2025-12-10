//
//  CalendarControllerAddTaskDelegate.swift
//  FitQuest
//
//  Created by Student on 12/2/25.
//

import UIKit

extension CalendarScreenViewController: AddTaskDelegate {
    func didCreateTask(_ task: FitQuestTask) {
        print("✅ Task created successfully!")
        print("  ID: \(task.id ?? "nil")")
        print("  Title: \(task.title)")
        print("  Category: \(task.category.displayName)")
        print("  Duration: \(task.duration) min")
        print("  XP: \(task.xpValue)")
        
        showAlert(title: "Success", message: "Task '\(task.title)' created successfully!")
    }
}
