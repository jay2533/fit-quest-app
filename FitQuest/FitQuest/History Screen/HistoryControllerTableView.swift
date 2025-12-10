//
//  HistoryControllerTableView.swift
//  FitQuest
//
//  Created by Student on 11/18/25.
//

import UIKit

extension HistoryScreenViewController: UITableViewDelegate, UITableViewDataSource {
        
    func numberOfSections(in tableView: UITableView) -> Int {
        if groupedTasks.isEmpty {
            showEmptyState()
            return 0
        } else {
            hideEmptyState()
            return groupedTasks.count
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupedTasks[section].tasks.count
    }
        
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: DateSectionHeaderView.identifier) as? DateSectionHeaderView else {
            return nil
        }
        
        let group = groupedTasks[section]
        header.configure(date: group.date, taskCount: group.tasks.count)
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HistoryTaskCell.identifier, for: indexPath) as? HistoryTaskCell else {
            return UITableViewCell()
        }
        
        let task = groupedTasks[indexPath.section].tasks[indexPath.row]
        cell.configure(with: task)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = groupedTasks[indexPath.section].tasks[indexPath.row]
        
        let detailVC = TaskDetailViewController(task: task)
        
        // Refresh list after deletion
        detailVC.onTaskDeleted = { [weak self] in
            self?.handleTaskDeleted()
        }
        
        if let sheet = detailVC.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = false
            sheet.preferredCornerRadius = 20
        }
        
        present(detailVC, animated: true)
    }
        
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        // Load more when user scrolls to 80% of content
        if offsetY > contentHeight - height * 1.2 {
            if !isLoading && hasMoreTasks {
                loadTasks(isLoadingMore: true)
            }
        }
    }
        
    private func handleTaskDeleted() {
        // Reset pagination and reload
        resetPagination()
        loadTasks()
    }
        
    func showEmptyState() {
        // Check if empty state already exists
        if historyView.tasksTableView.viewWithTag(999) != nil {
            return
        }
        
        let emptyStateView = UIView()
        emptyStateView.backgroundColor = .clear
        emptyStateView.tag = 999
        emptyStateView.translatesAutoresizingMaskIntoConstraints = false
        
        let iconImageView = UIImageView()
        iconImageView.image = UIImage(systemName: "clock.arrow.circlepath")
        iconImageView.tintColor = UIColor.lightGray.withAlphaComponent(0.5)
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        if selectedCategory != nil {
            titleLabel.text = "No tasks found"
        } else {
            titleLabel.text = "No task history yet"
        }
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        titleLabel.textColor = UIColor.lightGray
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let subtitleLabel = UILabel()
        if selectedCategory != nil {
            subtitleLabel.text = "Try a different filter or create new tasks"
        } else {
            subtitleLabel.text = "Complete tasks to see them here"
        }
        subtitleLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        subtitleLabel.textColor = UIColor.lightGray.withAlphaComponent(0.7)
        subtitleLabel.textAlignment = .center
        subtitleLabel.numberOfLines = 0
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        emptyStateView.addSubview(iconImageView)
        emptyStateView.addSubview(titleLabel)
        emptyStateView.addSubview(subtitleLabel)
        
        historyView.tasksTableView.addSubview(emptyStateView)
        
        NSLayoutConstraint.activate([
            emptyStateView.centerXAnchor.constraint(equalTo: historyView.tasksTableView.centerXAnchor),
            emptyStateView.centerYAnchor.constraint(equalTo: historyView.tasksTableView.centerYAnchor, constant: -40),
            emptyStateView.widthAnchor.constraint(equalTo: historyView.tasksTableView.widthAnchor, multiplier: 0.8),
            
            iconImageView.topAnchor.constraint(equalTo: emptyStateView.topAnchor),
            iconImageView.centerXAnchor.constraint(equalTo: emptyStateView.centerXAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 80),
            iconImageView.heightAnchor.constraint(equalToConstant: 80),
            
            titleLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: emptyStateView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: emptyStateView.trailingAnchor),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: emptyStateView.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: emptyStateView.trailingAnchor),
            subtitleLabel.bottomAnchor.constraint(equalTo: emptyStateView.bottomAnchor)
        ])
    }
    
    func hideEmptyState() {
        historyView.tasksTableView.subviews.forEach { subview in
            if subview.tag == 999 {
                subview.removeFromSuperview()
            }
        }
    }
}
