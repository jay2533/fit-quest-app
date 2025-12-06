//
//  TaskTypeSelectionViewController.swift
//  FitQuest
//
//  Created by Student on 12/4/25.
//

import UIKit

protocol TaskTypeSelectionDelegate: AnyObject {
    func didSelectCustomTask(category: TaskCategory, selectedDate: Date)
    func didSelectPredefinedTask(_ task: PredefinedTask, category: TaskCategory, selectedDate: Date)
}

class TaskTypeSelectionViewController: UIViewController {
    
    let taskTypeView: TaskTypeSelectionView
    weak var delegate: TaskTypeSelectionDelegate?
    
    var category: TaskCategory
    var selectedDate: Date
    var predefinedTasks: [PredefinedTask] = []
    
    init(category: TaskCategory, selectedDate: Date) {
        self.category = category
        self.selectedDate = selectedDate
        self.taskTypeView = TaskTypeSelectionView(frame: .zero, category: category)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = taskTypeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupActions()
        loadPredefinedTasks()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func setupActions() {
        // Close button
        taskTypeView.closeButton.addTarget(self, action: #selector(onCloseTapped), for: .touchUpInside)
        
        // Custom task button
        taskTypeView.customTaskButton.addTarget(self, action: #selector(onCustomTaskTapped), for: .touchUpInside)
    }
    
    func loadPredefinedTasks() {
        taskTypeView.showLoading()
        
        Task {
            do {
                // Fetch predefined tasks from Firebase for this category
                let tasks = try await TaskService.shared.fetchPredefinedTasks(category: category)
                
                await MainActor.run {
                    self.predefinedTasks = tasks
                    self.taskTypeView.hideLoading()
                    self.displayPredefinedTasks()
                }
            } catch {
                await MainActor.run {
                    self.taskTypeView.hideLoading()
                    print("Error fetching predefined tasks: \(error)")
                    
                    // Show error or just show custom task option
                    self.showAlert(title: "Error", message: "Could not load predefined tasks. You can still create a custom task.")
                }
            }
        }
    }
    
    func displayPredefinedTasks() {
        for (index, task) in predefinedTasks.enumerated() {
            let button = taskTypeView.addPredefinedTaskCard(task: task, tag: index)
            button.addTarget(self, action: #selector(onPredefinedTaskTapped(_:)), for: .touchUpInside)
        }
    }
    
    // MARK: - Actions
    
    @objc func onCloseTapped() {
        dismiss(animated: true)
    }
    
    @objc func onCustomTaskTapped() {
        print("Custom task selected for category: \(category.displayName)")
        delegate?.didSelectCustomTask(category: category, selectedDate: selectedDate)
        dismiss(animated: true)
    }
    
    @objc func onPredefinedTaskTapped(_ sender: UIButton) {
        let task = predefinedTasks[sender.tag]
        print("Predefined task selected: \(task.title)")
        
        delegate?.didSelectPredefinedTask(task, category: category, selectedDate: selectedDate)
        dismiss(animated: true)
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
