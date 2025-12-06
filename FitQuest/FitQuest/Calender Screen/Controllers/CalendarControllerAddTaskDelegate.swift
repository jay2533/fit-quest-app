//
//  CalendarControllerAddTaskDelegate.swift
//  FitQuest
//
//  Created by Student on 12/2/25.
//

import UIKit

// MARK: - AddTaskDelegate

extension CalendarScreenViewController: AddTaskDelegate {
    func didCreateTask(_ task: FitQuestTask) {
        print("✅ Task created successfully!")
        print("  ID: \(task.id ?? "nil")")
        print("  Title: \(task.title)")
        print("  Category: \(task.category.displayName)")
        print("  Duration: \(task.duration) min")
        print("  XP: \(task.xpValue)")
        
        // TODO: Reload tasks from Firebase for the selected date
        // For now, just show success message
        showAlert(title: "Success", message: "Task '\(task.title)' created successfully!")
        
        // TODO: Refresh task list
        // calendarView.tasksTableView.reloadData()
    }
}
