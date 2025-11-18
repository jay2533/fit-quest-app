//
//  HistoryTableViewCell.swift
//  FitQuest
//
//  Created by Student on 11/18/25.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {
    
    static let identifier = "CategoryHistoryCell"
        
    var containerView: UIView!
    var categoryLabel: UILabel!
    var taskCountLabel: UILabel!
    var chevronImageView: UIImageView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .clear
        self.selectionStyle = .none
        
        setupContainerView()
        setupCategoryLabel()
        setupTaskCountLabel()
        setupChevronImageView()
        
        initConstraints()
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
    
    func setupCategoryLabel() {
        categoryLabel = UILabel()
        categoryLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        categoryLabel.textColor = .white
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(categoryLabel)
    }
    
    func setupTaskCountLabel() {
        taskCountLabel = UILabel()
        taskCountLabel.font = .systemFont(ofSize: 14, weight: .regular)
        taskCountLabel.textColor = .lightGray
        taskCountLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(taskCountLabel)
    }
    
    func setupChevronImageView() {
        chevronImageView = UIImageView()
        let config = UIImage.SymbolConfiguration(pointSize: 14, weight: .semibold)
        chevronImageView.image = UIImage(systemName: "chevron.right", withConfiguration: config)
        chevronImageView.tintColor = .lightGray
        chevronImageView.contentMode = .scaleAspectFit
        chevronImageView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(chevronImageView)
    }
    
    func initConstraints() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -20),
            containerView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -8),
            containerView.heightAnchor.constraint(equalToConstant: 70),
            
            categoryLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 14),
            categoryLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            
            taskCountLabel.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 4),
            taskCountLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            taskCountLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -14),
            
            chevronImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            chevronImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            chevronImageView.widthAnchor.constraint(equalToConstant: 12),
            chevronImageView.heightAnchor.constraint(equalToConstant: 12)
        ])
    }
    
    func configure(category: String, taskCount: Int) {
        categoryLabel.text = category
        taskCountLabel.text = "– \(taskCount) tasks completed"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
