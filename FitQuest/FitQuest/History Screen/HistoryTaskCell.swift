//
//  HistoryTableViewCell.swift
//  FitQuest
//
//  Created by Student on 11/18/25.
//

import UIKit

class HistoryTaskCell: UITableViewCell {
    
    static let identifier = "HistoryTaskCell"
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 28/255, green: 41/255, blue: 56/255, alpha: 1.0)
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
    
    private let statusIconView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .white
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        label.textColor = UIColor.lightGray
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
    
    private let metadataStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
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
        label.text = "•"
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = UIColor(red: 156/255, green: 163/255, blue: 175/255, alpha: 1.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let xpLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(containerView)
        containerView.addSubview(leftBorderView)
        containerView.addSubview(statusIconView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(categoryLabel)
        containerView.addSubview(timeLabel)
        
        metadataStack.addArrangedSubview(durationLabel)
        metadataStack.addArrangedSubview(bulletLabel)
        metadataStack.addArrangedSubview(xpLabel)
        containerView.addSubview(metadataStack)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        // Set priorities BEFORE activating constraints
        timeLabel.setContentHuggingPriority(.required, for: .horizontal)
        timeLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            
            leftBorderView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            leftBorderView.topAnchor.constraint(equalTo: containerView.topAnchor),
            leftBorderView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            leftBorderView.widthAnchor.constraint(equalToConstant: 6),
            
            statusIconView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 18),
            statusIconView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            statusIconView.widthAnchor.constraint(equalToConstant: 22),
            statusIconView.heightAnchor.constraint(equalToConstant: 22),
            
            titleLabel.leadingAnchor.constraint(equalTo: statusIconView.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: timeLabel.leadingAnchor, constant: -8),
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            
            timeLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            timeLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            
            categoryLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            categoryLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            categoryLabel.trailingAnchor.constraint(lessThanOrEqualTo: containerView.trailingAnchor, constant: -16),
            
            metadataStack.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            metadataStack.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 4),
            metadataStack.trailingAnchor.constraint(lessThanOrEqualTo: containerView.trailingAnchor, constant: -16),
            metadataStack.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12),
        ])
    }
    
    func configure(with task: FitQuestTask) {
        // Title
        titleLabel.text = task.title
        
        // Category
        categoryLabel.text = task.category.displayName
        
        // Time
        let timeFormatter = DateFormatter()
        timeFormatter.timeStyle = .short
        timeLabel.text = timeFormatter.string(from: task.scheduledTime)
        
        // Duration
        durationLabel.text = formatDuration(task.duration)
        
        // XP - Only show if completed
        if task.isCompleted {
            xpLabel.text = "+\(task.xpValue) XP"
            xpLabel.textColor = UIColor(red: 139/255, green: 92/255, blue: 246/255, alpha: 1.0) // Purple
            xpLabel.isHidden = false
            bulletLabel.isHidden = false
        } else {
            xpLabel.isHidden = true
            bulletLabel.isHidden = true
        }
        
        // Status-based styling
        if task.isCompleted {
            statusIconView.image = UIImage(systemName: "checkmark.circle.fill")
            statusIconView.tintColor = UIColor(red: 16/255, green: 185/255, blue: 129/255, alpha: 1.0)
            leftBorderView.backgroundColor = UIColor(red: 16/255, green: 185/255, blue: 129/255, alpha: 1.0)
            containerView.backgroundColor = UIColor(red: 26/255, green: 47/255, blue: 47/255, alpha: 1.0)
            
        } else {
            // Incomplete/Missed - Red/Gray
            let isPast = task.scheduledTime < Date()
            
            if isPast {
                // Missed task - Red
                statusIconView.image = UIImage(systemName: "xmark.circle.fill")
                statusIconView.tintColor = UIColor(red: 239/255, green: 68/255, blue: 68/255, alpha: 1.0)
                leftBorderView.backgroundColor = UIColor(red: 239/255, green: 68/255, blue: 68/255, alpha: 1.0)
                containerView.backgroundColor = UIColor(red: 45/255, green: 20/255, blue: 20/255, alpha: 1.0)
            } else {
                // Future task
                statusIconView.image = UIImage(systemName: "circle")
                statusIconView.tintColor = UIColor.lightGray
                leftBorderView.backgroundColor = UIColor.lightGray
                containerView.backgroundColor = UIColor(red: 28/255, green: 41/255, blue: 56/255, alpha: 1.0)
            }
        }
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
