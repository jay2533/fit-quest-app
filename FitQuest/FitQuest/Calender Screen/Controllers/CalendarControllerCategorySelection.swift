//
//  CalendarControllerCategorySelection.swift
//  FitQuest
//
//  Created by Student on 12/4/25.
//
import UIKit

extension CalendarScreenViewController: CategorySelectionDelegate {
    func didSelectCategory(_ category: TaskCategory, selectedDate: Date) {
        print("Category selected: \(category.displayName) for date: \(selectedDate)")
        
        let taskTypeVC = TaskTypeSelectionViewController(category: category, selectedDate: selectedDate)
        taskTypeVC.delegate = self
        
        if let sheet = taskTypeVC.sheetPresentationController {
            sheet.detents = [.large()]
            sheet.prefersGrabberVisible = true
        }
        
        present(taskTypeVC, animated: true)
    }
}

extension CalendarScreenViewController: TaskTypeSelectionDelegate {
    func didSelectCustomTask(category: TaskCategory, selectedDate: Date) {
        print("Custom task selected for category: \(category.displayName)")
        
        if let presentedVC = self.presentedViewController {
            presentedVC.dismiss(animated: true) {
                self.showAddTaskForm(category: category, selectedDate: selectedDate, predefinedTask: nil)
            }
        } else {
            showAddTaskForm(category: category, selectedDate: selectedDate, predefinedTask: nil)
        }
    }
    
    func didSelectPredefinedTask(_ task: PredefinedTask, category: TaskCategory, selectedDate: Date) {
        print("Predefined task selected: \(task.title)")
        
        if let presentedVC = self.presentedViewController {
            presentedVC.dismiss(animated: true) {
                self.showAddTaskForm(category: category, selectedDate: selectedDate, predefinedTask: task)
            }
        } else {
            showAddTaskForm(category: category, selectedDate: selectedDate, predefinedTask: task)
        }
    }
    
    // Helper method to show AddTask form
    private func showAddTaskForm(category: TaskCategory, selectedDate: Date, predefinedTask: PredefinedTask?) {
        let addTaskVC = AddTaskViewController(
            category: category,
            selectedDate: selectedDate,
            predefinedTask: predefinedTask
        )
        addTaskVC.delegate = self
        
        if let sheet = addTaskVC.sheetPresentationController {
            sheet.detents = [.large()]
            sheet.prefersGrabberVisible = true
        }
        
        present(addTaskVC, animated: true) {
            print("✅ AddTaskViewController presented")
        }
    }
}
