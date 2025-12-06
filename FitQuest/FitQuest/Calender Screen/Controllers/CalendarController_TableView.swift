//
//  CalendarController_TableView.swift
//  FitQuest
//
//  Created by Student on 11/18/25.
//

import UIKit

// MARK: - UITableViewDelegate & UITableViewDataSource

extension CalendarScreenViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: TaskTableViewCell.identifier,
            for: indexPath
        ) as? TaskTableViewCell else {
            return UITableViewCell()
        }
        
        // ✅ UPDATED: Use real task from Firebase
        let task = tasks[indexPath.row]
        
        // Configure cell with real task data
        cell.configure(with: task, isCompleted: task.isCompleted)
        
        // Handle checkbox tap (still just visual for now)
        cell.onCheckboxTapped = { [weak self, weak cell] in
            guard let self = self, let cell = cell else { return }
            
            // Toggle completion state
            let newState = !cell.isTaskCompleted
            cell.updateCompletionState(isCompleted: newState, animated: true)
            
            print("✓ Checkbox tapped for task: \(task.title)")
            print("  Current state: \(newState ? "✅ Completed" : "⭕️ Incomplete")")
            
            // TODO: Next step - actually update Firebase
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 78
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // ✅ UPDATED: Use real task
        let task = tasks[indexPath.row]
        print("📋 Task cell tapped: \(task.title)")
        
        // TODO: Future - Show task detail modal
    }
}
