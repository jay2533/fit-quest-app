//
//  WeekDayCell.swift
//  FitQuest
//
//  Created by Student on 11/18/25.

import UIKit

class WeekDayCell: UICollectionViewCell {
    
    static let identifier = "WeekDayCell"
    
    var dayLabel: UILabel!
    var dateLabel: UILabel!
    var containerView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        // Container view
        containerView = UIView()
        containerView.backgroundColor = UIColor.white.withAlphaComponent(0.05)
        containerView.layer.cornerRadius = 12
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor(red: 0.33, green: 0.67, blue: 0.93, alpha: 0.3).cgColor
        containerView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(containerView)
        
        // Day label (S, M, T, W, etc.)
        dayLabel = UILabel()
        dayLabel.font = .systemFont(ofSize: 12, weight: .medium)
        dayLabel.textColor = .lightGray
        dayLabel.textAlignment = .center
        dayLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(dayLabel)
        
        // Date label (7, 8, 9, etc.)
        dateLabel = UILabel()
        dateLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        dateLabel.textColor = .white
        dateLabel.textAlignment = .center
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(dateLabel)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            
            dayLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            dayLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            
            dateLabel.topAnchor.constraint(equalTo: dayLabel.bottomAnchor, constant: 6),
            dateLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            dateLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12)
        ])
    }
    
    func configure(day: String, date: String, isSelected: Bool, isToday: Bool) {
        dayLabel.text = day
        dateLabel.text = date
        
        if isSelected {
            // Selected state - blue background
            containerView.backgroundColor = UIColor(red: 0.33, green: 0.67, blue: 0.93, alpha: 1.0)
            containerView.layer.borderColor = UIColor(red: 0.33, green: 0.67, blue: 0.93, alpha: 1.0).cgColor
            dateLabel.textColor = .white
            dayLabel.textColor = .white
        } else if isToday {
            // Today but not selected - blue border
            containerView.backgroundColor = UIColor.white.withAlphaComponent(0.05)
            containerView.layer.borderColor = UIColor(red: 0.33, green: 0.67, blue: 0.93, alpha: 1.0).cgColor
            containerView.layer.borderWidth = 2
            dateLabel.textColor = UIColor(red: 0.33, green: 0.67, blue: 0.93, alpha: 1.0)
            dayLabel.textColor = .lightGray
        } else {
            // Normal state
            containerView.backgroundColor = UIColor.white.withAlphaComponent(0.05)
            containerView.layer.borderColor = UIColor(red: 0.33, green: 0.67, blue: 0.93, alpha: 0.3).cgColor
            containerView.layer.borderWidth = 1
            dateLabel.textColor = .white
            dayLabel.textColor = .lightGray
        }
    }
}
