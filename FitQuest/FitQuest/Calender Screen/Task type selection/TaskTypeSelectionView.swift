//
//  TaskTypeSelectionView.swift
//  FitQuest
//
//  Created by Student on 12/4/25.
//

import UIKit

class TaskTypeSelectionView: UIView {
    
    var closeButton: UIButton!
    var titleContainer: UIStackView!
    var scrollView: UIScrollView!
    var contentView: UIView!
    var predefinedTasksLabel: UILabel!
    var predefinedTasksStackView: UIStackView!
    var customTaskButton: UIButton!
    var loadingIndicator: UIActivityIndicatorView!
    var category: TaskCategory
    
    init(frame: CGRect, category: TaskCategory) {
        self.category = category
        super.init(frame: frame)
        self.backgroundColor = UIColor(red: 0.08, green: 0.15, blue: 0.25, alpha: 1.0)
        
        setupScrollView()
        setupHeader()
        setupPredefinedTasksSection()
        setupCustomTaskButton()
        setupLoadingIndicator()
        
        initConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    func setupScrollView() {
        scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(scrollView)
        
        contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
    }
    
    func setupHeader() {
        closeButton = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold)
        closeButton.setImage(UIImage(systemName: "xmark", withConfiguration: config), for: .normal)
        closeButton.tintColor = .lightGray
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(closeButton)
    
        titleContainer = UIStackView()
        titleContainer.axis = .horizontal
        titleContainer.spacing = 8
        titleContainer.alignment = .center
        titleContainer.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleContainer)
        
        let iconConfig = UIImage.SymbolConfiguration(pointSize: 24, weight: .semibold)
        let iconImageView = UIImageView(image: UIImage(systemName: category.icon, withConfiguration: iconConfig))
        iconImageView.tintColor = .white
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = "\(category.displayName) Tasks"
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        titleLabel.textColor = .white
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleContainer.addArrangedSubview(iconImageView)
        titleContainer.addArrangedSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            iconImageView.widthAnchor.constraint(equalToConstant: 28),
            iconImageView.heightAnchor.constraint(equalToConstant: 28)
        ])
    }
    
    func setupPredefinedTasksSection() {
        predefinedTasksLabel = UILabel()
        predefinedTasksLabel.text = "PREDEFINED TASKS"
        predefinedTasksLabel.font = .systemFont(ofSize: 13, weight: .semibold)
        predefinedTasksLabel.textColor = .lightGray
        predefinedTasksLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(predefinedTasksLabel)
        
        predefinedTasksStackView = UIStackView()
        predefinedTasksStackView.axis = .vertical
        predefinedTasksStackView.spacing = 12
        predefinedTasksStackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(predefinedTasksStackView)
    }
    
    func setupCustomTaskButton() {
        customTaskButton = UIButton(type: .system)
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.alignment = .center
        stackView.isUserInteractionEnabled = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let iconConfig = UIImage.SymbolConfiguration(pointSize: 24, weight: .semibold)
        let iconImageView = UIImageView(image: UIImage(systemName: "plus.circle.fill", withConfiguration: iconConfig))
        iconImageView.tintColor = UIColor(red: 0.33, green: 0.67, blue: 0.93, alpha: 1.0)
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let label = UILabel()
        label.text = "Create Custom Task"
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.addArrangedSubview(iconImageView)
        stackView.addArrangedSubview(label)
        
        customTaskButton.addSubview(stackView)
        
        customTaskButton.backgroundColor = UIColor(red: 0.33, green: 0.67, blue: 0.93, alpha: 0.2)
        customTaskButton.layer.cornerRadius = 16
        customTaskButton.layer.borderWidth = 2
        customTaskButton.layer.borderColor = UIColor(red: 0.33, green: 0.67, blue: 0.93, alpha: 1.0).cgColor
        customTaskButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(customTaskButton)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: customTaskButton.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: customTaskButton.centerYAnchor),
            
            iconImageView.widthAnchor.constraint(equalToConstant: 28),
            iconImageView.heightAnchor.constraint(equalToConstant: 28)
        ])
    }
    
    func setupLoadingIndicator() {
        loadingIndicator = UIActivityIndicatorView(style: .large)
        loadingIndicator.color = UIColor(red: 0.33, green: 0.67, blue: 0.93, alpha: 1.0)
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(loadingIndicator)
    }
    
    func initConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            closeButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            closeButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            closeButton.widthAnchor.constraint(equalToConstant: 44),
            closeButton.heightAnchor.constraint(equalToConstant: 44),
            
            titleContainer.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleContainer.centerYAnchor.constraint(equalTo: closeButton.centerYAnchor),
            
            predefinedTasksLabel.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 24),
            predefinedTasksLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            predefinedTasksStackView.topAnchor.constraint(equalTo: predefinedTasksLabel.bottomAnchor, constant: 12),
            predefinedTasksStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            predefinedTasksStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            customTaskButton.topAnchor.constraint(equalTo: predefinedTasksStackView.bottomAnchor, constant: 24),
            customTaskButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            customTaskButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            customTaskButton.heightAnchor.constraint(equalToConstant: 70),
            customTaskButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: predefinedTasksStackView.centerXAnchor),
            loadingIndicator.topAnchor.constraint(equalTo: predefinedTasksLabel.bottomAnchor, constant: 40)
        ])
    }
        
    func addPredefinedTaskCard(task: PredefinedTask, tag: Int) -> UIButton {
        let button = UIButton(type: .custom)
        button.tag = tag
        
        let containerStack = UIStackView()
        containerStack.axis = .horizontal
        containerStack.spacing = 16
        containerStack.alignment = .center
        containerStack.isUserInteractionEnabled = false
        containerStack.translatesAutoresizingMaskIntoConstraints = false
        
        let iconConfig = UIImage.SymbolConfiguration(pointSize: 28, weight: .medium)
        let iconImageView = UIImageView(image: UIImage(systemName: task.iconName, withConfiguration: iconConfig))
        iconImageView.tintColor = .white
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let textStack = UIStackView()
        textStack.axis = .vertical
        textStack.spacing = 4
        textStack.alignment = .leading
        
        let titleLabel = UILabel()
        titleLabel.text = task.title
        titleLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        titleLabel.textColor = .white
        
        let durationLabel = UILabel()
        durationLabel.text = "Suggested: \(task.estimatedDuration) min"
        durationLabel.font = .systemFont(ofSize: 14, weight: .regular)
        durationLabel.textColor = .lightGray
        
        textStack.addArrangedSubview(titleLabel)
        textStack.addArrangedSubview(durationLabel)
        
        let chevronConfig = UIImage.SymbolConfiguration(pointSize: 16, weight: .semibold)
        let chevronImageView = UIImageView(image: UIImage(systemName: "chevron.right", withConfiguration: chevronConfig))
        chevronImageView.tintColor = .lightGray
        chevronImageView.contentMode = .scaleAspectFit
        chevronImageView.translatesAutoresizingMaskIntoConstraints = false
        
        containerStack.addArrangedSubview(iconImageView)
        containerStack.addArrangedSubview(textStack)
        containerStack.addArrangedSubview(chevronImageView)
        
        button.addSubview(containerStack)
        
        button.backgroundColor = UIColor.white.withAlphaComponent(0.05)
        button.layer.cornerRadius = 12
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(red: 0.33, green: 0.67, blue: 0.93, alpha: 0.3).cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: 80),
            
            containerStack.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: 16),
            containerStack.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -16),
            containerStack.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            
            iconImageView.widthAnchor.constraint(equalToConstant: 32),
            iconImageView.heightAnchor.constraint(equalToConstant: 32),
            
            chevronImageView.widthAnchor.constraint(equalToConstant: 12),
            chevronImageView.heightAnchor.constraint(equalToConstant: 12)
        ])
        
        predefinedTasksStackView.addArrangedSubview(button)
        return button
    }
    
    func showLoading() {
        loadingIndicator.startAnimating()
        predefinedTasksStackView.isHidden = true
    }
    
    func hideLoading() {
        loadingIndicator.stopAnimating()
        predefinedTasksStackView.isHidden = false
    }
}
