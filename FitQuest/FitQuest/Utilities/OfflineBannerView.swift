//
//  OfflineBannerView.swift
//  FitQuest
//
//  Created by Sunny Yadav on 12/10/25.
//

import UIKit

class OfflineBannerView: UIView {
    
    private let messageLabel = UILabel()
    private let iconImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = UIColor.systemRed.withAlphaComponent(0.9)
        
        iconImageView.image = UIImage(systemName: "wifi.slash")
        iconImageView.tintColor = .white
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(iconImageView)
        
        messageLabel.text = "No Internet Connection"
        messageLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        messageLabel.textColor = .white
        messageLabel.textAlignment = .center
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(messageLabel)
        
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 20),
            iconImageView.heightAnchor.constraint(equalToConstant: 20),
            
            messageLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 8),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            messageLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func show(in view: UIView) {
        self.alpha = 0
        self.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(self)
        
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            self.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            self.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        UIView.animate(withDuration: 0.3) {
            self.alpha = 1
        }
    }
    
    func hide() {
        UIView.animate(withDuration: 0.3) {
            self.alpha = 0
        } completion: { _ in
            self.removeFromSuperview()
        }
    }
}
