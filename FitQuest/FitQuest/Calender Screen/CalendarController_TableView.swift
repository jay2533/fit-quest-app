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
        return dummyTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.identifier, for: indexPath) as? TaskTableViewCell else {
            return UITableViewCell()
        }
        
        let task = dummyTasks[indexPath.row]
        cell.taskNameLabel.text = task.name
        cell.categoryBadge.text = task.category
        cell.timeLabel.text = task.time
        cell.completionLabel.text = task.completion
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 96
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = dummyTasks[indexPath.row]
        print("Task tapped: \(task.name)")
        // TODO: Navigate to task detail or mark complete
    }
}
