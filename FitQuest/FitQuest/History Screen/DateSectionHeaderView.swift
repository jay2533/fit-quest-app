//
//  DateSectionHeaderView.swift
//  FitQuest
//
//  Created by Student on 12/8/25.
//

import UIKit

class DateSectionHeaderView: UITableViewHeaderFooterView {
    
    static let identifier = "DateSectionHeaderView"
    
    // MARK: - UI Components
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        label.textColor = UIColor(red: 0.62, green: 0.79, blue: 0.97, alpha: 1.0) // Light blue
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let taskCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        label.textColor = UIColor.lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initialization
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupUI() {
        contentView.backgroundColor = UIColor(red: 0.08, green: 0.15, blue: 0.25, alpha: 1.0)
        
        contentView.addSubview(dateLabel)
        contentView.addSubview(taskCountLabel)
        
        NSLayoutConstraint.activate([
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            dateLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            taskCountLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            taskCountLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
    
    // MARK: - Configuration
    func configure(date: Date, taskCount: Int) {
        dateLabel.text = formatDate(date)
        taskCountLabel.text = "\(taskCount) task\(taskCount == 1 ? "" : "s")"
    }
    
    // MARK: - Helper
    private func formatDate(_ date: Date) -> String {
        let calendar = Calendar.current
        
        if calendar.isDateInToday(date) {
            return "📅 Today"
        } else if calendar.isDateInYesterday(date) {
            return "📅 Yesterday"
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "📅 EEEE, MMM d, yyyy" // e.g., "📅 Monday, Dec 8, 2025"
            return formatter.string(from: date)
        }
    }
}
