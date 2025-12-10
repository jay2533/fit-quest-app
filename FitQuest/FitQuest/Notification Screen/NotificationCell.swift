//
//  NotificationCell.swift
//  FitQuest
//
//  Created by Sunny Yadav on 12/2/25.
//

import UIKit

class NotificationCell: UITableViewCell {
    
    static let identifier = "NotificationCell"
    
    var containerView: UIView!
    var iconImageView: UIImageView!
    var titleLabel: UILabel!
    var messageLabel: UILabel!
    var timeLabel: UILabel!
    var unreadIndicator: UIView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell() {
        self.backgroundColor = .clear
        self.selectionStyle = .none
        
        containerView = UIView()
        containerView.backgroundColor = UIColor.white.withAlphaComponent(0.05)
        containerView.layer.cornerRadius = 12
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor(red: 0.16, green: 0.34, blue: 0.57, alpha: 0.5).cgColor
        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(containerView)
        
        iconImageView = UIImageView()
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = UIColor(red: 0.33, green: 0.67, blue: 0.93, alpha: 1.0)
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(iconImageView)
        
        titleLabel = UILabel()
        titleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 1
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(titleLabel)
        
        messageLabel = UILabel()
        messageLabel.font = .systemFont(ofSize: 14, weight: .regular)
        messageLabel.textColor = .lightGray
        messageLabel.numberOfLines = 2
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(messageLabel)
        
        timeLabel = UILabel()
        timeLabel.font = .systemFont(ofSize: 12, weight: .regular)
        timeLabel.textColor = .darkGray
        timeLabel.textAlignment = .right
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(timeLabel)
        
        unreadIndicator = UIView()
        unreadIndicator.backgroundColor = .systemRed
        unreadIndicator.layer.cornerRadius = 4
        unreadIndicator.isHidden = true
        unreadIndicator.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(unreadIndicator)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
            
            iconImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            iconImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            iconImageView.widthAnchor.constraint(equalToConstant: 32),
            iconImageView.heightAnchor.constraint(equalToConstant: 32),
            
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 12),
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: unreadIndicator.leadingAnchor, constant: -8),
            
            messageLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 12),
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            
            timeLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 12),
            timeLabel.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 4),
            timeLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            timeLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12),
            
            unreadIndicator.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            unreadIndicator.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            unreadIndicator.widthAnchor.constraint(equalToConstant: 8),
            unreadIndicator.heightAnchor.constraint(equalToConstant: 8)
        ])
    }
    
    func configure(with notification: AppNotification) {
        titleLabel.text = notification.title
        messageLabel.text = notification.message
        timeLabel.text = notification.createdAt.timeAgo()
        
        let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .medium)
        iconImageView.image = UIImage(systemName: notification.type.icon, withConfiguration: config)
        iconImageView.tintColor = notification.type.color
        
        unreadIndicator.isHidden = notification.isRead
        
        if !notification.isRead {
            containerView.backgroundColor = UIColor.white.withAlphaComponent(0.08)
            containerView.layer.borderColor = UIColor(red: 0.33, green: 0.67, blue: 0.93, alpha: 0.5).cgColor
        } else {
            containerView.backgroundColor = UIColor.white.withAlphaComponent(0.03)
            containerView.layer.borderColor = UIColor(red: 0.16, green: 0.34, blue: 0.57, alpha: 0.3).cgColor
        }
    }
}
