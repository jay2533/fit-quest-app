//
//  CategorySelectionView.swift
//  FitQuest
//
//  Created by Student on 12/4/25.
//

import UIKit

class CategorySelectionView: UIView {
    
    var titleLabel: UILabel!
    var categoryStackView: UIStackView!
    var categoryButtons: [UIButton] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(red: 0.08, green: 0.15, blue: 0.25, alpha: 1.0)
        
        setupTitleLabel()
        setupCategoryButtons()
        
        initConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupTitleLabel() {
        titleLabel = UILabel()
        titleLabel.text = "Select Category"
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(titleLabel)
    }
    
    func setupCategoryButtons() {
        // Create vertical stack view
        categoryStackView = UIStackView()
        categoryStackView.axis = .vertical
        categoryStackView.spacing = 16
        categoryStackView.distribution = .fillEqually
        categoryStackView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(categoryStackView)
        
        // Create buttons for each category
        for (index, category) in TaskCategory.allCases.enumerated() {
            let button = createCategoryButton(for: category, tag: index)
            categoryButtons.append(button)
            categoryStackView.addArrangedSubview(button)
        }
    }
    
    func createCategoryButton(for category: TaskCategory, tag: Int) -> UIButton {
        let button = UIButton(type: .custom)
        button.tag = tag
        
        // Container stack view (horizontal: icon + label)
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.alignment = .center
        stackView.isUserInteractionEnabled = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Icon
        let iconConfig = UIImage.SymbolConfiguration(pointSize: 32, weight: .medium)
        let iconImageView = UIImageView(image: UIImage(systemName: category.icon, withConfiguration: iconConfig))
        iconImageView.tintColor = .white
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        // Label
        let label = UILabel()
        label.text = category.displayName
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.addArrangedSubview(iconImageView)
        stackView.addArrangedSubview(label)
        
        button.addSubview(stackView)
        
        // Button styling
        button.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        button.layer.cornerRadius = 16
        button.layer.borderWidth = 1.5
        button.layer.borderColor = hexStringToUIColor(hex: category.colorHex).withAlphaComponent(0.5).cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: 70),
            
            stackView.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: 24),
            stackView.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            
            iconImageView.widthAnchor.constraint(equalToConstant: 36),
            iconImageView.heightAnchor.constraint(equalToConstant: 36)
        ])
        
        return button
    }
    
    func initConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            
            categoryStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 32),
            categoryStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            categoryStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            categoryStackView.bottomAnchor.constraint(lessThanOrEqualTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -24)
        ])
    }
    
    // Helper: Convert hex string to UIColor
    func hexStringToUIColor(hex: String) -> UIColor {
        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }
        
        if cString.count != 6 {
            return UIColor.gray
        }
        
        var rgbValue: UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: 1.0
        )
    }
}

