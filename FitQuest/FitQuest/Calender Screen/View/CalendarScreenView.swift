//
//  CalenderScreenView.swift
//  FitQuest
//
//  Created by Student on 11/17/25.
//

import UIKit

class CalendarScreenView: UIView {

    var logoImageView: UIImageView!
    var titleLabel: UILabel!
    var profileButton: UIButton!
    
    var monthYearLabel: UILabel!
    var previousWeekButton: UIButton!
    var nextWeekButton: UIButton!
    
    var weekCollectionView: UICollectionView!
    
    var tasksTableView: UITableView!
    
    var addTaskButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(red: 0.08, green: 0.15, blue: 0.25, alpha: 1.0)
        
        setupHeader()
        setupMonthYearLabel()
        setupWeekNavigationButtons()
        setupWeekCollectionView()
        setupTasksTableView()
        setupAddTaskButton()
        
        initConstraints()
    }
    
    // MARK: - Setup Methods
    
    func setupHeader() {
        // Logo
        logoImageView = UIImageView()
        logoImageView.contentMode = .scaleAspectFit
        let config = UIImage.SymbolConfiguration(pointSize: 30, weight: .medium)
        logoImageView.image = UIImage(systemName: "arrow.up.heart.fill", withConfiguration: config)
        logoImageView.tintColor = UIColor(red: 0.33, green: 0.67, blue: 0.93, alpha: 1.0)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(logoImageView)
        
        // Title
        titleLabel = UILabel()
        titleLabel.text = "Calendar"
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(titleLabel)
        
        // Profile Button
        profileButton = UIButton(type: .system)
        let profileConfig = UIImage.SymbolConfiguration(pointSize: 28, weight: .medium)
        profileButton.setImage(UIImage(systemName: "person.circle.fill", withConfiguration: profileConfig), for: .normal)
        profileButton.tintColor = UIColor(red: 0.33, green: 0.67, blue: 0.93, alpha: 1.0)
        profileButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(profileButton)
    }
    
    func setupMonthYearLabel() {
        monthYearLabel = UILabel()
        
        // Set current month and year
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        monthYearLabel.text = dateFormatter.string(from: Date())
        
        monthYearLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        monthYearLabel.textColor = .white
        monthYearLabel.textAlignment = .center
        monthYearLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(monthYearLabel)
    }
    
    func setupWeekNavigationButtons() {
        // Previous Week Button
        previousWeekButton = UIButton(type: .system)
        let leftConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold)
        previousWeekButton.setImage(UIImage(systemName: "chevron.left", withConfiguration: leftConfig), for: .normal)
        previousWeekButton.tintColor = UIColor(red: 0.33, green: 0.67, blue: 0.93, alpha: 1.0)
        previousWeekButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(previousWeekButton)
        
        // Next Week Button
        nextWeekButton = UIButton(type: .system)
        let rightConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold)
        nextWeekButton.setImage(UIImage(systemName: "chevron.right", withConfiguration: rightConfig), for: .normal)
        nextWeekButton.tintColor = UIColor(red: 0.33, green: 0.67, blue: 0.93, alpha: 1.0)
        nextWeekButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(nextWeekButton)
    }
    
    func setupWeekCollectionView() {
        // Create flow layout
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        weekCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        weekCollectionView.backgroundColor = .clear
        weekCollectionView.showsHorizontalScrollIndicator = false
        weekCollectionView.isScrollEnabled = false
        weekCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        // Register cell
        weekCollectionView.register(WeekDayCell.self, forCellWithReuseIdentifier: WeekDayCell.identifier)
        
        self.addSubview(weekCollectionView)
    }
    
    func setupTasksTableView() {
        tasksTableView = UITableView()
        tasksTableView.backgroundColor = .clear
        tasksTableView.separatorStyle = .none
        tasksTableView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(tasksTableView)
        
        // Register a basic cell
        tasksTableView.register(TaskTableViewCell.self, forCellReuseIdentifier: "TaskCell")
    }
    
    func setupAddTaskButton() {
        addTaskButton = UIButton(type: .system)
        
        // Create circular button with + icon
        let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .semibold)
        addTaskButton.setImage(UIImage(systemName: "plus", withConfiguration: config), for: .normal)
        addTaskButton.tintColor = .white
        addTaskButton.backgroundColor = UIColor(red: 0.33, green: 0.67, blue: 0.93, alpha: 1.0)
        
        // Make it circular
        addTaskButton.layer.cornerRadius = 28
        
        // Add shadow for elevation
        addTaskButton.layer.shadowColor = UIColor.black.cgColor
        addTaskButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        addTaskButton.layer.shadowOpacity = 0.3
        addTaskButton.layer.shadowRadius = 8
        
        addTaskButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(addTaskButton)
    }
    
    func initConstraints() {
        NSLayoutConstraint.activate([
            // Logo (top left) - use safeAreaLayoutGuide for top
            logoImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            logoImageView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 10),
            logoImageView.widthAnchor.constraint(equalToConstant: 35),
            logoImageView.heightAnchor.constraint(equalToConstant: 35),
            
            // Title (center)
            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: logoImageView.centerYAnchor),
            
            // Profile Button (top right)
            profileButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            profileButton.centerYAnchor.constraint(equalTo: logoImageView.centerYAnchor),
            profileButton.widthAnchor.constraint(equalToConstant: 35),
            profileButton.heightAnchor.constraint(equalToConstant: 35),
            
            // Month/Year Label
            monthYearLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 25),
            monthYearLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            monthYearLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            
            // Previous Week Button
            previousWeekButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            previousWeekButton.topAnchor.constraint(equalTo: monthYearLabel.bottomAnchor, constant: 15),
            previousWeekButton.widthAnchor.constraint(equalToConstant: 44),
            previousWeekButton.heightAnchor.constraint(equalToConstant: 44),
            
            // Next Week Button
            nextWeekButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            nextWeekButton.centerYAnchor.constraint(equalTo: previousWeekButton.centerYAnchor),
            nextWeekButton.widthAnchor.constraint(equalToConstant: 44),
            nextWeekButton.heightAnchor.constraint(equalToConstant: 44),
            
            // Week Collection View
            weekCollectionView.topAnchor.constraint(equalTo: previousWeekButton.bottomAnchor, constant: 15),
            weekCollectionView.leadingAnchor.constraint(equalTo: previousWeekButton.trailingAnchor, constant: 10),
            weekCollectionView.trailingAnchor.constraint(equalTo: nextWeekButton.leadingAnchor, constant: -10),
            weekCollectionView.heightAnchor.constraint(equalToConstant: 80),  
            
            // Tasks Table View - use safeAreaLayoutGuide for bottom
            tasksTableView.topAnchor.constraint(equalTo: weekCollectionView.bottomAnchor, constant: 25),
            tasksTableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            tasksTableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            tasksTableView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            
            // Add Task Button (floating bottom right) - use safeAreaLayoutGuide for bottom
            addTaskButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -25),
            addTaskButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -25),
            addTaskButton.widthAnchor.constraint(equalToConstant: 56),
            addTaskButton.heightAnchor.constraint(equalToConstant: 56)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
