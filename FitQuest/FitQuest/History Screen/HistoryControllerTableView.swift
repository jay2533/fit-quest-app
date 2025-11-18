//
//  HistoryControllerTableView.swift
//  FitQuest
//
//  Created by Student on 11/18/25.
//

import UIKit

// MARK: - UITableViewDelegate & UITableViewDataSource

extension HistoryScreenViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HistoryTableViewCell.identifier, for: indexPath) as? HistoryTableViewCell else {
            return UITableViewCell()
        }
        
        let category = categoryData[indexPath.row]
        cell.configure(category: category.name, taskCount: category.count)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 86  // 70 (cell height) + 16 (top + bottom margins)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = categoryData[indexPath.row]
        print("Category tapped: \(category.name)")
        // TODO: Navigate to detailed task list for this category
    }
}

