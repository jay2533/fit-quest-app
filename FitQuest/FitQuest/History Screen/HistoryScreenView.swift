//
//  HistoryScreenView.swift
//  FitQuest
//
//  Created by Student on 11/18/25.
//

import UIKit

class HistoryScreenView: UIView {

    var logoImageView: UIImageView!
    var titleLabel: UILabel!
    var filterButton: UIButton!
    var backButton: UIButton!
    
    var filterBadgeView: UIView!
    var filterBadgeLabel: UILabel!
    var clearFilterButton: UIButton!
    
    var tasksTableView: UITableView!
    
    var loadingIndicator: UIActivityIndicatorView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(red: 0.08, green: 0.15, blue: 0.25, alpha: 1.0)
        
        setupHeader()
        setupFilterBadge()
        setupTasksTableView()
        setupLoadingIndicator()
        
        initConstraints()
    }
            
    func setupHeader() {
        logoImageView = UIImageView()
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.image = UIImage(named: "fitquest_logo")?.withRenderingMode(.alwaysOriginal)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(logoImageView)
        
        backButton = UIButton(type: .system)
        let backConfig = UIImage.SymbolConfiguration(pointSize: 22, weight: .medium)
        backButton.setImage(UIImage(systemName: "chevron.left", withConfiguration: backConfig), for: .normal)
        backButton.tintColor = UIColor(red: 0.62, green: 0.79, blue: 0.97, alpha: 1.0)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(backButton)
        
        titleLabel = UILabel()
        titleLabel.text = "Task History"
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(titleLabel)
        
        filterButton = UIButton(type: .system)
        let filterConfig = UIImage.SymbolConfiguration(pointSize: 22, weight: .medium)
        filterButton.setImage(UIImage(systemName: "line.3.horizontal.decrease.circle", withConfiguration: filterConfig), for: .normal)
        filterButton.tintColor = UIColor(red: 0.33, green: 0.67, blue: 0.93, alpha: 1.0)
        filterButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(filterButton)
    }
    
    func setupFilterBadge() {
        filterBadgeView = UIView()
        filterBadgeView.backgroundColor = UIColor(red: 0.33, green: 0.67, blue: 0.93, alpha: 0.2)
        filterBadgeView.layer.cornerRadius = 20
        filterBadgeView.layer.borderWidth = 1
        filterBadgeView.layer.borderColor = UIColor(red: 0.33, green: 0.67, blue: 0.93, alpha: 0.5).cgColor
        filterBadgeView.isHidden = true
        filterBadgeView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(filterBadgeView)
        
        filterBadgeLabel = UILabel()
        filterBadgeLabel.text = "Mental"
        filterBadgeLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        filterBadgeLabel.textColor = UIColor(red: 0.62, green: 0.79, blue: 0.97, alpha: 1.0)
        filterBadgeLabel.translatesAutoresizingMaskIntoConstraints = false
        filterBadgeView.addSubview(filterBadgeLabel)
        
        clearFilterButton = UIButton(type: .system)
        let xConfig = UIImage.SymbolConfiguration(pointSize: 12, weight: .bold)
        clearFilterButton.setImage(UIImage(systemName: "xmark.circle.fill", withConfiguration: xConfig), for: .normal)
        clearFilterButton.tintColor = UIColor(red: 0.62, green: 0.79, blue: 0.97, alpha: 1.0)
        clearFilterButton.translatesAutoresizingMaskIntoConstraints = false
        filterBadgeView.addSubview(clearFilterButton)
        
        NSLayoutConstraint.activate([
            filterBadgeLabel.leadingAnchor.constraint(equalTo: filterBadgeView.leadingAnchor, constant: 16),
            filterBadgeLabel.centerYAnchor.constraint(equalTo: filterBadgeView.centerYAnchor),
            
            clearFilterButton.leadingAnchor.constraint(equalTo: filterBadgeLabel.trailingAnchor, constant: 8),
            clearFilterButton.trailingAnchor.constraint(equalTo: filterBadgeView.trailingAnchor, constant: -12),
            clearFilterButton.centerYAnchor.constraint(equalTo: filterBadgeView.centerYAnchor),
            clearFilterButton.widthAnchor.constraint(equalToConstant: 20),
            clearFilterButton.heightAnchor.constraint(equalToConstant: 20),
        ])
    }
    
    func setupTasksTableView() {
        tasksTableView = UITableView()
        tasksTableView.backgroundColor = .clear
        tasksTableView.separatorStyle = .none
        tasksTableView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(tasksTableView)
        
        tasksTableView.register(HistoryTaskCell.self, forCellReuseIdentifier: HistoryTaskCell.identifier)
        tasksTableView.register(DateSectionHeaderView.self, forHeaderFooterViewReuseIdentifier: DateSectionHeaderView.identifier)
    }
    
    func setupLoadingIndicator() {
        loadingIndicator = UIActivityIndicatorView(style: .large)
        loadingIndicator.color = UIColor(red: 0.33, green: 0.67, blue: 0.93, alpha: 1.0)
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(loadingIndicator)
    }
    
    func initConstraints() {
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 16),
            logoImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 40),
            logoImageView.heightAnchor.constraint(equalToConstant: 40),
            
            backButton.centerYAnchor.constraint(equalTo: logoImageView.centerYAnchor),
            backButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            backButton.widthAnchor.constraint(equalToConstant: 32),
            backButton.heightAnchor.constraint(equalToConstant: 32),
            
            filterButton.centerYAnchor.constraint(equalTo: logoImageView.centerYAnchor),
            filterButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            filterButton.widthAnchor.constraint(equalToConstant: 32),
            filterButton.heightAnchor.constraint(equalToConstant: 32),
            
            titleLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 40),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -40),
            
            filterBadgeView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            filterBadgeView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            filterBadgeView.heightAnchor.constraint(equalToConstant: 40),
            
            tasksTableView.topAnchor.constraint(equalTo: filterBadgeView.bottomAnchor, constant: 8),
            tasksTableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            tasksTableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            tasksTableView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: tasksTableView.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: tasksTableView.centerYAnchor),
        ])
    }
        
    func showFilterBadge(categoryName: String) {
        filterBadgeLabel.text = categoryName
        filterBadgeView.isHidden = false
        
        filterBadgeView.alpha = 0
        filterBadgeView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: [], animations: {
            self.filterBadgeView.alpha = 1
            self.filterBadgeView.transform = .identity
        })
    }
    
    func hideFilterBadge() {
        UIView.animate(withDuration: 0.2, animations: {
            self.filterBadgeView.alpha = 0
            self.filterBadgeView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }) { _ in
            self.filterBadgeView.isHidden = true
            self.filterBadgeView.transform = .identity
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
