//
//  TaskDetailViewController.swift
//  FitQuest
//
//  Created by Student on 12/8/25.
//

import UIKit

class TaskDetailViewController: UIViewController {
    
    // MARK: - Properties
    private let task: FitQuestTask
    
    // MARK: - UI Components
    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let dragHandle: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        view.layer.cornerRadius = 2.5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let categoryIconView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .white
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let metadataLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.textColor = UIColor.lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let divider1: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let scheduledTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "📅 Scheduled"
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let scheduledValueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = UIColor.lightGray
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let notesTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "📝 Notes"
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let notesValueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = UIColor.lightGray
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let divider2: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let editButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Edit Task", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        button.setTitleColor(.lightGray, for: .normal)
        button.layer.cornerRadius = 12
        button.isEnabled = false // ✅ Disabled for now
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Close", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Initialization
    init(task: FitQuestTask) {
        self.task = task
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureWithTask()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = UIColor(red: 0.08, green: 0.15, blue: 0.25, alpha: 1.0)
        
        view.addSubview(dragHandle)
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(categoryIconView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(metadataLabel)
        contentView.addSubview(divider1)
        contentView.addSubview(scheduledTitleLabel)
        contentView.addSubview(scheduledValueLabel)
        contentView.addSubview(notesTitleLabel)
        contentView.addSubview(notesValueLabel)
        contentView.addSubview(divider2)
        contentView.addSubview(statusLabel)
        contentView.addSubview(editButton)
        contentView.addSubview(closeButton)
        
        setupConstraints()
        setupActions()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Drag Handle
            dragHandle.topAnchor.constraint(equalTo: view.topAnchor, constant: 12),
            dragHandle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dragHandle.widthAnchor.constraint(equalToConstant: 40),
            dragHandle.heightAnchor.constraint(equalToConstant: 5),
            
            // Scroll View
            scrollView.topAnchor.constraint(equalTo: dragHandle.bottomAnchor, constant: 12),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            // Content View
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // Category Icon
            categoryIconView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            categoryIconView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            categoryIconView.widthAnchor.constraint(equalToConstant: 32),
            categoryIconView.heightAnchor.constraint(equalToConstant: 32),
            
            // Title
            titleLabel.leadingAnchor.constraint(equalTo: categoryIconView.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            titleLabel.centerYAnchor.constraint(equalTo: categoryIconView.centerYAnchor),
            
            // Metadata
            metadataLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            metadataLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            metadataLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            
            // Divider 1
            divider1.topAnchor.constraint(equalTo: metadataLabel.bottomAnchor, constant: 24),
            divider1.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            divider1.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            divider1.heightAnchor.constraint(equalToConstant: 1),
            
            // Scheduled Title
            scheduledTitleLabel.topAnchor.constraint(equalTo: divider1.bottomAnchor, constant: 24),
            scheduledTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            scheduledTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            
            // Scheduled Value
            scheduledValueLabel.topAnchor.constraint(equalTo: scheduledTitleLabel.bottomAnchor, constant: 8),
            scheduledValueLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40),
            scheduledValueLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            
            // Notes Title
            notesTitleLabel.topAnchor.constraint(equalTo: scheduledValueLabel.bottomAnchor, constant: 20),
            notesTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            notesTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            
            // Notes Value
            notesValueLabel.topAnchor.constraint(equalTo: notesTitleLabel.bottomAnchor, constant: 8),
            notesValueLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40),
            notesValueLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            
            // Divider 2
            divider2.topAnchor.constraint(equalTo: notesValueLabel.bottomAnchor, constant: 24),
            divider2.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            divider2.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            divider2.heightAnchor.constraint(equalToConstant: 1),
            
            // Status
            statusLabel.topAnchor.constraint(equalTo: divider2.bottomAnchor, constant: 24),
            statusLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            statusLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            
            // Edit Button
            editButton.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 32),
            editButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            editButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            editButton.heightAnchor.constraint(equalToConstant: 50),
            
            // Close Button
            closeButton.topAnchor.constraint(equalTo: editButton.bottomAnchor, constant: 16),
            closeButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            closeButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24),
        ])
    }
    
    private func setupActions() {
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Configuration
    private func configureWithTask() {
        // Icon
        let iconName = getCategoryIcon(for: task.category)
        categoryIconView.image = UIImage(systemName: iconName)
        
        // Title
        titleLabel.text = task.title
        
        // Metadata (Category • Duration • XP)
        metadataLabel.text = "\(task.category.displayName) • \(formatDuration(task.duration)) • \(task.xpValue) XP"
        
        // Scheduled
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .short
        scheduledValueLabel.text = dateFormatter.string(from: task.scheduledTime)
        
        // Notes
        if let notes = task.notes, !notes.isEmpty {
            notesValueLabel.text = notes
        } else {
            notesValueLabel.text = "No notes"
            notesValueLabel.textColor = UIColor.darkGray
        }
        
        // Status
        if task.isCompleted {
            if let completedAt = task.completedAt {
                let timeFormatter = DateFormatter()
                timeFormatter.timeStyle = .short
                statusLabel.text = "✅ Completed at \(timeFormatter.string(from: completedAt))"
                statusLabel.textColor = UIColor(red: 16/255, green: 185/255, blue: 129/255, alpha: 1.0)
            } else {
                statusLabel.text = "✅ Completed"
                statusLabel.textColor = UIColor(red: 16/255, green: 185/255, blue: 129/255, alpha: 1.0)
            }
        } else {
            statusLabel.text = "⭕️ Not completed"
            statusLabel.textColor = UIColor.lightGray
        }
    }
    
    // MARK: - Actions
    @objc private func closeButtonTapped() {
        dismiss(animated: true)
    }
    
    // MARK: - Helpers
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
