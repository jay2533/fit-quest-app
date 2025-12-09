//
//  LeaderboardTableViewCell.swift
//  FitQuest
//
//  Created by Rushad Daruwalla on 12/9/25.
//

import UIKit

class LeaderboardTableViewCell: UITableViewCell {
    
    static let identifier = "LeaderboardTableViewCell"
    
    private let rankLabel = UILabel()
    private let avatarImageView = UIImageView()
    private let nameLabel = UILabel()
    private let xpLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        rankLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        rankLabel.textColor = .white
        rankLabel.textAlignment = .left
        rankLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(rankLabel)
        
        avatarImageView.layer.cornerRadius = 18
        avatarImageView.clipsToBounds = true
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(avatarImageView)
        
        nameLabel.font = .systemFont(ofSize: 16, weight: .regular)
        nameLabel.textColor = .white
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(nameLabel)
        
        xpLabel.font = .systemFont(ofSize: 14, weight: .medium)
        xpLabel.textColor = UIColor(red: 0.62, green: 0.79, blue: 0.97, alpha: 1.0)
        xpLabel.textAlignment = .right
        xpLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(xpLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            rankLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            rankLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            rankLabel.widthAnchor.constraint(equalToConstant: 30),
            
            avatarImageView.leadingAnchor.constraint(equalTo: rankLabel.trailingAnchor, constant: 8),
            avatarImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 36),
            avatarImageView.heightAnchor.constraint(equalToConstant: 36),
            
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 12),
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            xpLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            xpLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            xpLabel.leadingAnchor.constraint(greaterThanOrEqualTo: nameLabel.trailingAnchor, constant: 8)
        ])
    }
    
    func configure(entry: LeaderboardEntry, avatar: UIImage?) {
        rankLabel.text = "#\(entry.rank)"
        nameLabel.text = entry.name
        xpLabel.text = "\(entry.totalXP) XP"
        avatarImageView.image = avatar
    }
}
