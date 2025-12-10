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
    var backButton: UIButton!
    
    var monthYearLabel: UILabel!
    
    var weekCollectionView: UICollectionView!
    
    var previousWeekButton: UIButton!
    var nextWeekButton: UIButton!
    
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    
    func setupHeader() {
        // Logo (center, decorative – not a button anymore)
        logoImageView = UIImageView()
        logoImageView.contentMode = .scaleAspectFit
        let config = UIImage.SymbolConfiguration(pointSize: 30, weight: .medium)
        logoImageView.image = UIImage(systemName: "arrow.up.heart.fill", withConfiguration: config)
        logoImageView.tintColor = UIColor(red: 0.33, green: 0.67, blue: 0.93, alpha: 1.0)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.isUserInteractionEnabled = false
        self.addSubview(logoImageView)
        
        // Back button (same style as LeaderboardView)
        backButton = UIButton(type: .system)
        let backConfig = UIImage.SymbolConfiguration(pointSize: 22, weight: .medium)
        backButton.setImage(UIImage(systemName: "chevron.left", withConfiguration: backConfig), for: .normal)
        backButton.tintColor = UIColor(red: 0.62, green: 0.79, blue: 0.97, alpha: 1.0)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(backButton)
        
        // Title
        titleLabel = UILabel()
        titleLabel.text = "Calendar"
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(titleLabel)
    }
    
    func setupMonthYearLabel() {
        monthYearLabel = UILabel()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        monthYearLabel.text = dateFormatter.string(from: Date())
        
        monthYearLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        monthYearLabel.textColor = .white
        monthYearLabel.textAlignment = .center
        monthYearLabel.isUserInteractionEnabled = true
        monthYearLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(monthYearLabel)
    }
    
    func setupWeekCollectionView() {
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
        
        weekCollectionView.register(WeekDayCell.self, forCellWithReuseIdentifier: WeekDayCell.identifier)
        
        self.addSubview(weekCollectionView)
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
    
    func setupTasksTableView() {
        tasksTableView = UITableView()
        tasksTableView.backgroundColor = .clear
        tasksTableView.separatorStyle = .none
        tasksTableView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(tasksTableView)
        
        tasksTableView.register(TaskTableViewCell.self, forCellReuseIdentifier: "TaskCell")
    }
    
    func setupAddTaskButton() {
        addTaskButton = UIButton(type: .system)
        
        let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .semibold)
        addTaskButton.setImage(UIImage(systemName: "plus", withConfiguration: config), for: .normal)
        addTaskButton.tintColor = .white
        addTaskButton.backgroundColor = UIColor(red: 0.33, green: 0.67, blue: 0.93, alpha: 1.0)
        
        addTaskButton.layer.cornerRadius = 28
        
        addTaskButton.layer.shadowColor = UIColor.black.cgColor
        addTaskButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        addTaskButton.layer.shadowOpacity = 0.3
        addTaskButton.layer.shadowRadius = 8
        
        addTaskButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(addTaskButton)
    }
    
    func initConstraints() {
        NSLayoutConstraint.activate([
            // Logo centered at top (like leaderboard)
            logoImageView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 16),
            logoImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 40),
            logoImageView.heightAnchor.constraint(equalToConstant: 40),
            
            // Back button on left, same row as logo
            backButton.centerYAnchor.constraint(equalTo: logoImageView.centerYAnchor),
            backButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            backButton.widthAnchor.constraint(equalToConstant: 32),
            backButton.heightAnchor.constraint(equalToConstant: 32),
            
            // Title below logo
            titleLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 4),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 40),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -40),
            
            // Month/Year Label below title
            monthYearLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            monthYearLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            monthYearLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            
            // Week Collection View (we reference it earlier in constraints, so it needs a top)
            weekCollectionView.topAnchor.constraint(equalTo: monthYearLabel.bottomAnchor, constant: 15),
            weekCollectionView.leadingAnchor.constraint(equalTo: previousWeekButton.trailingAnchor, constant: 8),
            weekCollectionView.trailingAnchor.constraint(equalTo: nextWeekButton.leadingAnchor, constant: -8),
            weekCollectionView.heightAnchor.constraint(equalToConstant: 80),
            
            // Previous Week Button
            previousWeekButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            previousWeekButton.centerYAnchor.constraint(equalTo: weekCollectionView.centerYAnchor),
            previousWeekButton.widthAnchor.constraint(equalToConstant: 40),
            previousWeekButton.heightAnchor.constraint(equalToConstant: 40),

            // Next Week Button
            nextWeekButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
            nextWeekButton.centerYAnchor.constraint(equalTo: weekCollectionView.centerYAnchor),
            nextWeekButton.widthAnchor.constraint(equalToConstant: 40),
            nextWeekButton.heightAnchor.constraint(equalToConstant: 40),
            
            // Tasks Table View
            tasksTableView.topAnchor.constraint(equalTo: weekCollectionView.bottomAnchor, constant: 25),
            tasksTableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            tasksTableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            tasksTableView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            
            // Add Task Button (floating bottom right)
            addTaskButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -25),
            addTaskButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -25),
            addTaskButton.widthAnchor.constraint(equalToConstant: 56),
            addTaskButton.heightAnchor.constraint(equalToConstant: 56)
        ])
    }
}
