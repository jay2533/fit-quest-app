//
//  TaskTableViewCell.swift
//  FitQuest
//
//  Created by Student on 11/18/25.
//

import UIKit

class TaskTableViewCell: UITableViewCell {
    
    static let identifier = "TaskTableViewCell"
    
    var onCheckboxTapped: (() -> Void)?
    var currentTask: FitQuestTask?
    var isTaskCompleted: Bool = false
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 28/255, green: 41/255, blue: 56/255, alpha: 1.0) // Dark gray-blue
        view.layer.cornerRadius = 12
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        view.layer.shadowOpacity = 0.2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let leftBorderView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let categoryIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .systemGray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = UIColor(red: 156/255, green: 163/255, blue: 175/255, alpha: 1.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let checkboxButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "square"), for: .normal)
        button.tintColor = UIColor(red: 209/255, green: 213/255, blue: 219/255, alpha: 1.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let durationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = UIColor(red: 156/255, green: 163/255, blue: 175/255, alpha: 1.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let bulletLabel: UILabel = {
        let label = UILabel()
        label.text = " • "
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = UIColor(red: 156/255, green: 163/255, blue: 175/255, alpha: 1.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let xpLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        label.textColor = UIColor(red: 139/255, green: 92/255, blue: 246/255, alpha: 1.0) // Purple
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(containerView)
        containerView.addSubview(leftBorderView)
        containerView.addSubview(categoryIconImageView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(timeLabel)
        containerView.addSubview(checkboxButton)
        containerView.addSubview(durationLabel)
        containerView.addSubview(bulletLabel)
        containerView.addSubview(xpLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            containerView.heightAnchor.constraint(equalToConstant: 70),
            
            leftBorderView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            leftBorderView.topAnchor.constraint(equalTo: containerView.topAnchor),
            leftBorderView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            leftBorderView.widthAnchor.constraint(equalToConstant: 6),
            
            categoryIconImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 18),
            categoryIconImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            categoryIconImageView.widthAnchor.constraint(equalToConstant: 20),
            categoryIconImageView.heightAnchor.constraint(equalToConstant: 20),
            
            titleLabel.leadingAnchor.constraint(equalTo: categoryIconImageView.trailingAnchor, constant: 8),
            titleLabel.centerYAnchor.constraint(equalTo: categoryIconImageView.centerYAnchor),
            
            timeLabel.trailingAnchor.constraint(equalTo: checkboxButton.leadingAnchor, constant: -12),
            timeLabel.centerYAnchor.constraint(equalTo: categoryIconImageView.centerYAnchor),
            
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: timeLabel.leadingAnchor, constant: -8),
            
            checkboxButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            checkboxButton.centerYAnchor.constraint(equalTo: categoryIconImageView.centerYAnchor),
            checkboxButton.widthAnchor.constraint(equalToConstant: 24),
            checkboxButton.heightAnchor.constraint(equalToConstant: 24),
            
            durationLabel.leadingAnchor.constraint(equalTo: categoryIconImageView.leadingAnchor),
            durationLabel.topAnchor.constraint(equalTo: categoryIconImageView.bottomAnchor, constant: 8),
            
            bulletLabel.leadingAnchor.constraint(equalTo: durationLabel.trailingAnchor),
            bulletLabel.centerYAnchor.constraint(equalTo: durationLabel.centerYAnchor),
            
            xpLabel.leadingAnchor.constraint(equalTo: bulletLabel.trailingAnchor),
            xpLabel.centerYAnchor.constraint(equalTo: durationLabel.centerYAnchor),
        ])
    }
    
    private func setupActions() {
        checkboxButton.addTarget(self, action: #selector(checkboxTapped), for: .touchUpInside)
    }
    
    @objc private func checkboxTapped() {
        onCheckboxTapped?()
    }

    func configure(with task: FitQuestTask, isCompleted: Bool = false) {
        // Store task and state
        self.currentTask = task
        self.isTaskCompleted = isCompleted
        
        // Title
        titleLabel.text = task.title
        
        // Category Icon
        let iconName = getCategoryIcon(for: task.category)
        categoryIconImageView.image = UIImage(systemName: iconName)
        
        // Category Color
        let categoryColor = getCategoryColor(for: task.category)
        categoryIconImageView.tintColor = categoryColor
        
        // Time
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        timeLabel.text = formatter.string(from: task.scheduledTime)
        
        // Duration
        durationLabel.text = formatDuration(task.duration)
        
        // XP
        xpLabel.text = "\(task.xpValue) XP"
        
        // Check if task is overdue
        let isOverdue = !isCompleted && task.scheduledTime < Date()
        
        // Completion State (includes overdue styling)
        updateCompletionState(isCompleted: isCompleted, isOverdue: isOverdue, animated: false)
    }
    
    func updateCompletionState(isCompleted: Bool, isOverdue: Bool = false, animated: Bool = true) {
        // Update internal state
        self.isTaskCompleted = isCompleted
        
        let duration = animated ? 0.3 : 0.0
        
        // Get the original category color
        let categoryColor = currentTask != nil ? getCategoryColor(for: currentTask!.category) : UIColor.systemGray
        
        if isCompleted {
            // Completed state - dark blue-green tint
            UIView.animate(withDuration: duration) {
                self.containerView.backgroundColor = UIColor(red: 26/255, green: 47/255, blue: 47/255, alpha: 1.0)
                self.leftBorderView.backgroundColor = UIColor(red: 16/255, green: 185/255, blue: 129/255, alpha: 1.0) // Bright green
                self.checkboxButton.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
                self.checkboxButton.tintColor = UIColor(red: 16/255, green: 185/255, blue: 129/255, alpha: 1.0)
                self.timeLabel.textColor = UIColor(red: 156/255, green: 163/255, blue: 175/255, alpha: 1.0) // Normal gray
            }
        } else if isOverdue {
            // Overdue state - red tint
            UIView.animate(withDuration: duration) {
                self.containerView.backgroundColor = UIColor(red: 45/255, green: 20/255, blue: 20/255, alpha: 1.0) // Dark red tint
                self.leftBorderView.backgroundColor = UIColor(red: 239/255, green: 68/255, blue: 68/255, alpha: 1.0) // Bright red
                self.checkboxButton.setImage(UIImage(systemName: "square"), for: .normal)
                self.checkboxButton.tintColor = UIColor(red: 209/255, green: 213/255, blue: 219/255, alpha: 1.0)
                self.timeLabel.textColor = UIColor(red: 239/255, green: 68/255, blue: 68/255, alpha: 1.0) // Red time
            }
        } else {
            // Incomplete state - dark gray-blue
            UIView.animate(withDuration: duration) {
                self.containerView.backgroundColor = UIColor(red: 28/255, green: 41/255, blue: 56/255, alpha: 1.0)
                self.leftBorderView.backgroundColor = categoryColor // Bright category color
                self.checkboxButton.setImage(UIImage(systemName: "square"), for: .normal)
                self.checkboxButton.tintColor = UIColor(red: 209/255, green: 213/255, blue: 219/255, alpha: 1.0)
                self.timeLabel.textColor = UIColor(red: 156/255, green: 163/255, blue: 175/255, alpha: 1.0) // Normal gray
            }
        }
        
        // Haptic feedback
        if animated {
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
        }
    }
        
    private func getCategoryIcon(for category: TaskCategory) -> String {
        switch category {
        case .physical:
            return "figure.run"
        case .mental:
            return "brain.head.profile"
        case .social:
            return "person.2.fill"
        case .creativity:
            return "paintpalette.fill"
        case .miscellaneous:
            return "list.bullet"
        }
    }
    
    private func getCategoryColor(for category: TaskCategory) -> UIColor {
        // All icons same color - pure white
        return UIColor.white
    }

    private func formatDuration(_ minutes: Int) -> String {
        if minutes < 60 {
            return "\(minutes) min"
        } else {
            let hours = minutes / 60
            let remainingMinutes = minutes % 60
            if remainingMinutes == 0 {
                return "\(hours) hr"
            } else {
                return "\(hours) hr \(remainingMinutes) min"
            }
        }
    }
}
