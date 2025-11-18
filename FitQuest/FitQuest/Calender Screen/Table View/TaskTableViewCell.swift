//
//  TaskTableViewCell.swift
//  FitQuest
//
//  Created by Student on 11/18/25.
//

import UIKit

class TaskTableViewCell: UITableViewCell {

    var taskNameLabel: UILabel!
    var categoryBadge: UILabel!
    var timeLabel: UILabel!
    var completionLabel: UILabel!
    var containerView: UIView!
    
    static let identifier = "TaskCell"
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .clear
        self.selectionStyle = .none
        
        setupContainerView()
        setupTaskNameLabel()
        setupCategoryBadge()
        setupTimeLabel()
        setupCompletionLabel()
        
        initConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupContainerView() {
        containerView = UIView()
        containerView.backgroundColor = UIColor.white.withAlphaComponent(0.05)
        containerView.layer.cornerRadius = 12
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor(red: 0.33, green: 0.67, blue: 0.93, alpha: 0.3).cgColor
        containerView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(containerView)
    }
    
    func setupTaskNameLabel() {
        taskNameLabel = UILabel()
        taskNameLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        taskNameLabel.textColor = .white
        taskNameLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(taskNameLabel)
    }
    
    func setupCategoryBadge() {
        categoryBadge = UILabel()
        categoryBadge.font = .systemFont(ofSize: 12, weight: .medium)
        categoryBadge.textColor = UIColor(red: 0.33, green: 0.67, blue: 0.93, alpha: 1.0)
        categoryBadge.backgroundColor = UIColor(red: 0.33, green: 0.67, blue: 0.93, alpha: 0.2)
        categoryBadge.layer.cornerRadius = 8
        categoryBadge.clipsToBounds = true
        categoryBadge.textAlignment = .center
        categoryBadge.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(categoryBadge)
    }
    
    func setupTimeLabel() {
        timeLabel = UILabel()
        timeLabel.font = .systemFont(ofSize: 14, weight: .regular)
        timeLabel.textColor = .lightGray
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(timeLabel)
    }
    
    func setupCompletionLabel() {
        completionLabel = UILabel()
        completionLabel.font = .systemFont(ofSize: 14, weight: .medium)
        completionLabel.textColor = .lightGray
        completionLabel.textAlignment = .right
        completionLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(completionLabel)
    }
    
    func initConstraints() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -20),
            containerView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -8),
            containerView.heightAnchor.constraint(greaterThanOrEqualToConstant: 80),
            
            taskNameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            taskNameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            taskNameLabel.trailingAnchor.constraint(equalTo: categoryBadge.leadingAnchor, constant: -8),
            
            categoryBadge.centerYAnchor.constraint(equalTo: taskNameLabel.centerYAnchor),
            categoryBadge.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            categoryBadge.widthAnchor.constraint(greaterThanOrEqualToConstant: 60),
            categoryBadge.heightAnchor.constraint(equalToConstant: 24),
            
            timeLabel.topAnchor.constraint(equalTo: taskNameLabel.bottomAnchor, constant: 8),
            timeLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            timeLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12),
            
            completionLabel.centerYAnchor.constraint(equalTo: timeLabel.centerYAnchor),
            completionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16)
        ])
    }
}
