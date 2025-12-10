//
//  CalendarController_TableView.swift
//  FitQuest
//
//  Created by Student on 11/18/25.
//

import UIKit
import FirebaseAuth

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
        
        let task = tasks[indexPath.row]
        
        // Configure cell with task data
        cell.configure(with: task, isCompleted: task.isCompleted)
        
        // Handle checkbox tap with Firebase persistence
        cell.onCheckboxTapped = { [weak self] in
            self?.handleTaskCompletion(task: task, cell: cell)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 78
    }
    
    // MARK: - Show Task Detail on Tap
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let task = tasks[indexPath.row]
        print("📋 Task cell tapped: \(task.title)")
        
        // Show task detail bottom sheet
        showTaskDetail(for: task)
    }
    
    // MARK: - Swipe-to-Delete (Swipe RIGHT)
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let task = tasks[indexPath.row]
        
        // ✅ CHECK: Only allow delete for incomplete tasks
        if task.isCompleted {
            // Completed task - show "Cannot Delete" action (disabled style)
            let cannotDeleteAction = UIContextualAction(style: .normal, title: "Completed") { [weak self] (action, view, completionHandler) in
                // Show message
                self?.showCannotDeleteCompletedAlert()
                completionHandler(false)
            }
            
            cannotDeleteAction.backgroundColor = UIColor.systemGray
            cannotDeleteAction.image = UIImage(systemName: "checkmark.circle.fill")
            
            let configuration = UISwipeActionsConfiguration(actions: [cannotDeleteAction])
            configuration.performsFirstActionWithFullSwipe = false
            
            return configuration
            
        } else {
            // Incomplete task - allow delete
            let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, view, completionHandler) in
                self?.confirmDeleteTask(task: task, at: indexPath)
                completionHandler(true)
            }
            
            deleteAction.backgroundColor = .systemRed
            deleteAction.image = UIImage(systemName: "trash.fill")
            
            let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
            configuration.performsFirstActionWithFullSwipe = false // Requires tap, not full swipe
            
            return configuration
        }
    }
    
    // MARK: - Show Task Detail
    private func showTaskDetail(for task: FitQuestTask) {
        let detailVC = TaskDetailViewController(task: task)
        
        if let sheet = detailVC.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = false // We have custom drag handle
            sheet.preferredCornerRadius = 20
        }
        
        present(detailVC, animated: true)
    }
    
    // MARK: - Delete Confirmation
    private func confirmDeleteTask(task: FitQuestTask, at indexPath: IndexPath) {
        let alert = UIAlertController(
            title: "Delete Task?",
            message: "Are you sure you want to delete \"\(task.title)\"?\n\nThis cannot be undone.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            self?.deleteTask(task: task, at: indexPath)
        })
        
        present(alert, animated: true)
    }
    
    // MARK: - Delete Task
    private func deleteTask(task: FitQuestTask, at indexPath: IndexPath) {
        guard let taskId = task.id else { return }
        
        Task {
            do {
                // Delete from Firebase
                try await TaskService.shared.deleteTask(taskId: taskId)
                
                print("🗑️ Task deleted: \(task.title)")
                
                // Show confirmation toast
                await MainActor.run {
                    showXPToast("Task deleted")
                }
                
            } catch {
                await MainActor.run {
                    // ✅ More specific error message
                    self.showErrorToast("Failed to unmark task")
                }
                print("❌ Error deleting task: \(error)")
            }
        }
    }
    
    // MARK: - Task Completion Handler
    private func handleTaskCompletion(task: FitQuestTask, cell: TaskTableViewCell) {
        guard let taskId = task.id else {
            print("❌ Task ID missing")
            return
        }
        
        let newCompletionState = !task.isCompleted
        
        if newCompletionState {
            markTaskComplete(taskId: taskId, task: task, cell: cell)
        } else {
            unmarkTask(taskId: taskId, task: task, cell: cell)
        }
    }
    
    // MARK: - Mark Task Complete
    private func markTaskComplete(taskId: String, task: FitQuestTask, cell: TaskTableViewCell) {
        // Update to completed state (removes overdue styling)
        cell.updateCompletionState(isCompleted: true, isOverdue: false, animated: true)
        
        Task {
            do {
                guard let userId = Auth.auth().currentUser?.uid else {
                    await MainActor.run {
                        self.showErrorToast("User not logged in")
                    }
                    return
                }
                
                // 1. Mark task complete (awards XP)
                try await TaskService.shared.completeTask(taskId: taskId)
                
                // 2. Update stats (no XP, just stats + level/tier)
                try await StatsService.shared.updateStatsAfterTaskCompletion(userId: userId, task: task)
                
                await MainActor.run {
                    showXPToast("+\(task.xpValue) XP")
                }
                
            } catch {
                await MainActor.run {
                    // Revert to overdue state if was overdue
                    let isOverdue = task.scheduledTime < Date()
                    cell.updateCompletionState(isCompleted: false, isOverdue: isOverdue, animated: true)
                    self.showErrorToast("Failed to complete task")
                }
            }
        }
    }

    // MARK: - Unmark Task
    private func unmarkTask(taskId: String, task: FitQuestTask, cell: TaskTableViewCell) {
        Task {
            do {
                guard let userId = Auth.auth().currentUser?.uid else {
                    await MainActor.run {
                        self.showErrorToast("User not logged in")
                    }
                    return
                }
                
                // 1. Unmark task (deducts XP)
                try await TaskService.shared.unmarkTask(taskId: taskId)
                
                // 2. Reverse stats (task counts, category XP, daily progress)
                try await StatsService.shared.reverseStatsAfterUnmark(userId: userId, task: task)
                
                await MainActor.run {
                    // Check if task is now overdue when unmarking
                    let isOverdue = task.scheduledTime < Date()
                    cell.updateCompletionState(isCompleted: false, isOverdue: isOverdue, animated: true)
                    showXPToast("-\(task.xpValue) XP")
                }
                
            } catch let error as NSError {
                if error.code == -2 {
                    await MainActor.run {
                        // Revert to completed state
                        cell.updateCompletionState(isCompleted: true, isOverdue: false, animated: true)
                        showCannotUnmarkAlert()
                    }
                } else {
                    await MainActor.run {
                        // Revert to completed state
                        cell.updateCompletionState(isCompleted: true, isOverdue: false, animated: true)
                        self.showErrorToast("Failed to unmark task")
                    }
                }
            }
        }
    }
    
    // MARK: - UI Helpers
    private func showCannotUnmarkAlert() {
        let alert = UIAlertController(
            title: "Cannot Undo",
            message: "Tasks can only be unmarked within 5 minutes of completion.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    // Cannot Delete Completed Task Alert
    private func showCannotDeleteCompletedAlert() {
        let alert = UIAlertController(
            title: "Cannot Delete",
            message: "Completed tasks cannot be deleted to preserve your XP and task history.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func showXPToast(_ message: String) {
        let toastLabel = UILabel()
        toastLabel.text = message
        toastLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        toastLabel.textColor = .white
        toastLabel.backgroundColor = UIColor(red: 16/255, green: 185/255, blue: 129/255, alpha: 0.9)
        toastLabel.textAlignment = .center
        toastLabel.layer.cornerRadius = 20
        toastLabel.clipsToBounds = true
        toastLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(toastLabel)
        
        NSLayoutConstraint.activate([
            toastLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            toastLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100),
            toastLabel.widthAnchor.constraint(equalToConstant: 120),
            toastLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        toastLabel.alpha = 0
        UIView.animate(withDuration: 0.3, animations: {
            toastLabel.alpha = 1
        }) { _ in
            UIView.animate(withDuration: 0.3, delay: 1.5, options: [], animations: {
                toastLabel.alpha = 0
            }) { _ in
                toastLabel.removeFromSuperview()
            }
        }
    }
}
