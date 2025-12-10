//
//  AddTaskView.swift
//  FitQuest
//
//  Created by Student on 12/2/25.
//

import UIKit

class AddTaskView: UIView {
    
    var closeButton: UIButton!
    var titleLabel: UILabel!
    var scrollView: UIScrollView!
    var contentView: UIView!
    var taskDetailsLabel: UILabel!
    var taskNameTextField: UITextField!
    var durationLabel: UILabel!
    var durationButton: UIButton!
    var durationPicker: UIPickerView!
    var durationPickerVisible: Bool = false
    var difficultyLabel: UILabel!
    var difficultySegmentedControl: UISegmentedControl!
    var scheduleLabel: UILabel!
    var dateButton: UIButton!
    var datePicker: UIDatePicker!
    var datePickerVisible: Bool = false
    var timeButton: UIButton!
    var timePicker: UIDatePicker!
    var timePickerVisible: Bool = false
    var notesLabel: UILabel!
    var notesTextView: UITextView!
    var createButton: UIButton!
    var durationPickerHeightConstraint: NSLayoutConstraint!
    var datePickerHeightConstraint: NSLayoutConstraint!
    var timePickerHeightConstraint: NSLayoutConstraint!
    var scheduleLabelTopConstraint: NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(red: 0.08, green: 0.15, blue: 0.25, alpha: 1.0)
        
        setupScrollView()
        setupHeader()
        setupTaskDetailsSection()
        setupDurationSection()
        setupDifficultySection()
        setupScheduleSection()
        setupNotesSection()
        setupCreateButton()
        
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
        
        titleLabel = UILabel()
        titleLabel.text = "Add Task"
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
    }
    
    func setupTaskDetailsSection() {
        taskDetailsLabel = UILabel()
        taskDetailsLabel.text = "TASK DETAILS"
        taskDetailsLabel.font = .systemFont(ofSize: 13, weight: .semibold)
        taskDetailsLabel.textColor = .lightGray
        taskDetailsLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(taskDetailsLabel)
        
        taskNameTextField = UITextField()
        taskNameTextField.placeholder = "Enter task name"
        taskNameTextField.textColor = .white
        taskNameTextField.font = .systemFont(ofSize: 16)
        taskNameTextField.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        taskNameTextField.layer.cornerRadius = 12
        taskNameTextField.layer.borderWidth = 1
        taskNameTextField.layer.borderColor = UIColor(red: 0.33, green: 0.67, blue: 0.93, alpha: 0.3).cgColor
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        taskNameTextField.leftView = paddingView
        taskNameTextField.leftViewMode = .always
        
        taskNameTextField.attributedPlaceholder = NSAttributedString(
            string: "Enter task name",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        )
        
        taskNameTextField.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(taskNameTextField)
    }
    
    func setupDurationSection() {
        durationLabel = UILabel()
        durationLabel.text = "Duration *"
        durationLabel.font = .systemFont(ofSize: 13, weight: .semibold)
        durationLabel.textColor = .lightGray
        durationLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(durationLabel)
        
        durationButton = UIButton(type: .system)
        durationButton.translatesAutoresizingMaskIntoConstraints = false
        
        var durationConfig = UIButton.Configuration.filled()
        durationConfig.title = "30 minutes"
        durationConfig.baseForegroundColor = .white
        durationConfig.baseBackgroundColor = UIColor.white.withAlphaComponent(0.1)
        durationConfig.cornerStyle = .medium
        
        let timerConfig = UIImage.SymbolConfiguration(pointSize: 18, weight: .medium)
        durationConfig.image = UIImage(systemName: "timer", withConfiguration: timerConfig)
        durationConfig.imagePlacement = .trailing
        durationConfig.imagePadding = 8
        
        durationConfig.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16)
        durationConfig.titleAlignment = .leading
        
        durationButton.configuration = durationConfig
        durationButton.tintColor = UIColor(red: 0.33, green: 0.67, blue: 0.93, alpha: 1.0)
        
        durationButton.layer.cornerRadius = 12
        durationButton.layer.borderWidth = 1
        durationButton.layer.borderColor = UIColor(red: 0.33, green: 0.67, blue: 0.93, alpha: 0.3).cgColor
        
        contentView.addSubview(durationButton)
        
        durationPicker = UIPickerView()
        durationPicker.backgroundColor = UIColor.white.withAlphaComponent(0.05)
        durationPicker.layer.cornerRadius = 12
        durationPicker.translatesAutoresizingMaskIntoConstraints = false
        durationPicker.isHidden = true
        contentView.addSubview(durationPicker)
    }
    
    func setupDifficultySection() {
        difficultyLabel = UILabel()
        difficultyLabel.text = "Difficulty (For Custom Tasks)"
        difficultyLabel.font = .systemFont(ofSize: 13, weight: .semibold)
        difficultyLabel.textColor = .lightGray
        difficultyLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(difficultyLabel)
        
        difficultySegmentedControl = UISegmentedControl(items: ["Easy", "Medium", "Hard"])
        difficultySegmentedControl.selectedSegmentIndex = 1 // Default: Medium
        difficultySegmentedControl.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        difficultySegmentedControl.selectedSegmentTintColor = UIColor(red: 0.33, green: 0.67, blue: 0.93, alpha: 1.0)
        
        let normalTextAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.lightGray,
            .font: UIFont.systemFont(ofSize: 14, weight: .medium)
        ]
        let selectedTextAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 14, weight: .semibold)
        ]
        
        difficultySegmentedControl.setTitleTextAttributes(normalTextAttributes, for: .normal)
        difficultySegmentedControl.setTitleTextAttributes(selectedTextAttributes, for: .selected)
        
        difficultySegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(difficultySegmentedControl)
    }
    
    func setupScheduleSection() {
        scheduleLabel = UILabel()
        scheduleLabel.text = "SCHEDULE"
        scheduleLabel.font = .systemFont(ofSize: 13, weight: .semibold)
        scheduleLabel.textColor = .lightGray
        scheduleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(scheduleLabel)

        dateButton = UIButton(type: .system)
        dateButton.translatesAutoresizingMaskIntoConstraints = false
        
        var dateConfig = UIButton.Configuration.filled()
        dateConfig.title = "Dec 5, 2025 (Today)"  // Will be updated dynamically
        dateConfig.baseForegroundColor = .white
        dateConfig.baseBackgroundColor = UIColor.white.withAlphaComponent(0.1)
        dateConfig.cornerStyle = .medium
        
        let calendarConfig = UIImage.SymbolConfiguration(pointSize: 18, weight: .medium)
        dateConfig.image = UIImage(systemName: "calendar", withConfiguration: calendarConfig)
        dateConfig.imagePlacement = .trailing
        dateConfig.imagePadding = 8
        
        dateConfig.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16)
        dateConfig.titleAlignment = .leading
        
        dateButton.configuration = dateConfig
        dateButton.tintColor = UIColor(red: 0.33, green: 0.67, blue: 0.93, alpha: 1.0)
        
        dateButton.layer.cornerRadius = 12
        dateButton.layer.borderWidth = 1
        dateButton.layer.borderColor = UIColor(red: 0.33, green: 0.67, blue: 0.93, alpha: 0.3).cgColor
        
        contentView.addSubview(dateButton)
        
        datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .inline
        datePicker.minimumDate = Date()
        datePicker.tintColor = UIColor(red: 0.33, green: 0.67, blue: 0.93, alpha: 1.0)
        datePicker.backgroundColor = UIColor.white.withAlphaComponent(0.05)
        datePicker.layer.cornerRadius = 12
        datePicker.overrideUserInterfaceStyle = .dark
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.isHidden = true
        contentView.addSubview(datePicker)

        timeButton = UIButton(type: .system)
        timeButton.translatesAutoresizingMaskIntoConstraints = false
        
        var timeConfig = UIButton.Configuration.filled()
        timeConfig.title = "11:59 PM"  // Will be updated dynamically
        timeConfig.baseForegroundColor = .white
        timeConfig.baseBackgroundColor = UIColor.white.withAlphaComponent(0.1)
        timeConfig.cornerStyle = .medium
        
        let clockConfig = UIImage.SymbolConfiguration(pointSize: 18, weight: .medium)
        timeConfig.image = UIImage(systemName: "clock", withConfiguration: clockConfig)
        timeConfig.imagePlacement = .trailing
        timeConfig.imagePadding = 8
        
        timeConfig.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16)
        timeConfig.titleAlignment = .leading
        
        timeButton.configuration = timeConfig
        timeButton.tintColor = UIColor(red: 0.33, green: 0.67, blue: 0.93, alpha: 1.0)
        
        timeButton.layer.cornerRadius = 12
        timeButton.layer.borderWidth = 1
        timeButton.layer.borderColor = UIColor(red: 0.33, green: 0.67, blue: 0.93, alpha: 0.3).cgColor
        
        contentView.addSubview(timeButton)
        
        timePicker = UIDatePicker()
        timePicker.datePickerMode = .time
        timePicker.preferredDatePickerStyle = .wheels
        timePicker.tintColor = UIColor(red: 0.33, green: 0.67, blue: 0.93, alpha: 1.0)
        timePicker.backgroundColor = UIColor.white.withAlphaComponent(0.05)
        timePicker.layer.cornerRadius = 12
        timePicker.overrideUserInterfaceStyle = .dark
        
        // Set default time to 11:59 PM (end of day)
        var components = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        components.hour = 23
        components.minute = 59
        if let endOfDay = Calendar.current.date(from: components) {
            timePicker.date = endOfDay
        }
        
        timePicker.translatesAutoresizingMaskIntoConstraints = false
        timePicker.isHidden = true
        contentView.addSubview(timePicker)
    }
    
    func setupNotesSection() {
        notesLabel = UILabel()
        notesLabel.text = "Notes (Optional)"
        notesLabel.font = .systemFont(ofSize: 13, weight: .semibold)
        notesLabel.textColor = .lightGray
        notesLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(notesLabel)
        
        notesTextView = UITextView()
        notesTextView.text = "Add notes here..."
        notesTextView.textColor = .lightGray
        notesTextView.font = .systemFont(ofSize: 16)
        notesTextView.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        notesTextView.layer.cornerRadius = 12
        notesTextView.layer.borderWidth = 1
        notesTextView.layer.borderColor = UIColor(red: 0.33, green: 0.67, blue: 0.93, alpha: 0.3).cgColor
        notesTextView.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        notesTextView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(notesTextView)
    }
    
    func setupCreateButton() {
        createButton = UIButton(type: .system)
        createButton.setTitle("Create Task", for: .normal)
        createButton.setTitleColor(.white, for: .normal)
        createButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        createButton.backgroundColor = UIColor(red: 0.33, green: 0.67, blue: 0.93, alpha: 1.0)
        createButton.layer.cornerRadius = 25
        createButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(createButton)
    }
    
    func initConstraints() {
        durationPickerHeightConstraint = durationPicker.heightAnchor.constraint(equalToConstant: 0)
        datePickerHeightConstraint = datePicker.heightAnchor.constraint(equalToConstant: 0)
        timePickerHeightConstraint = timePicker.heightAnchor.constraint(equalToConstant: 0)
        
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
            
            titleLabel.centerYAnchor.constraint(equalTo: closeButton.centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            taskDetailsLabel.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 24),
            taskDetailsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            taskNameTextField.topAnchor.constraint(equalTo: taskDetailsLabel.bottomAnchor, constant: 8),
            taskNameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            taskNameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            taskNameTextField.heightAnchor.constraint(equalToConstant: 50),
            
            durationLabel.topAnchor.constraint(equalTo: taskNameTextField.bottomAnchor, constant: 24),
            durationLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            durationButton.topAnchor.constraint(equalTo: durationLabel.bottomAnchor, constant: 8),
            durationButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            durationButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            durationButton.heightAnchor.constraint(equalToConstant: 50),
            
            durationPicker.topAnchor.constraint(equalTo: durationButton.bottomAnchor, constant: 8),
            durationPicker.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            durationPicker.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            durationPickerHeightConstraint,  // Uses dynamic constraint
            
            difficultyLabel.topAnchor.constraint(equalTo: durationPicker.bottomAnchor, constant: 24),
            difficultyLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            difficultySegmentedControl.topAnchor.constraint(equalTo: difficultyLabel.bottomAnchor, constant: 8),
            difficultySegmentedControl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            difficultySegmentedControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            difficultySegmentedControl.heightAnchor.constraint(equalToConstant: 40),
            
            scheduleLabel.topAnchor.constraint(equalTo: difficultySegmentedControl.bottomAnchor, constant: 24),
            scheduleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            dateButton.topAnchor.constraint(equalTo: scheduleLabel.bottomAnchor, constant: 8),
            dateButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            dateButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            dateButton.heightAnchor.constraint(equalToConstant: 50),
            
            datePicker.topAnchor.constraint(equalTo: dateButton.bottomAnchor, constant: 8),
            datePicker.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            datePicker.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            datePickerHeightConstraint,  // Uses dynamic constraint
            
            timeButton.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 16),
            timeButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            timeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            timeButton.heightAnchor.constraint(equalToConstant: 50),
            
            // Time Picker - DYNAMIC HEIGHT
            timePicker.topAnchor.constraint(equalTo: timeButton.bottomAnchor, constant: 8),
            timePicker.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            timePicker.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            timePickerHeightConstraint,  // Uses dynamic constraint
            
            notesLabel.topAnchor.constraint(equalTo: timePicker.bottomAnchor, constant: 24),
            notesLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            notesTextView.topAnchor.constraint(equalTo: notesLabel.bottomAnchor, constant: 8),
            notesTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            notesTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            notesTextView.heightAnchor.constraint(equalToConstant: 100),
            
            createButton.topAnchor.constraint(equalTo: notesTextView.bottomAnchor, constant: 32),
            createButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40),
            createButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),
            createButton.heightAnchor.constraint(equalToConstant: 50),
            createButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40)
        ])
    }
        
    func showDurationPicker() {
        durationPickerHeightConstraint.constant = 150
        durationPicker.isHidden = false
    }
    
    func hideDurationPicker() {
        durationPickerHeightConstraint.constant = 0
        durationPicker.isHidden = true
    }
    
    func showDatePicker() {
        datePickerHeightConstraint.constant = 320
        datePicker.isHidden = false
    }
    
    func hideDatePicker() {
        datePickerHeightConstraint.constant = 0
        datePicker.isHidden = true
    }
    
    func showTimePicker() {
        timePickerHeightConstraint.constant = 200
        timePicker.isHidden = false
    }
    
    func hideTimePicker() {
        timePickerHeightConstraint.constant = 0
        timePicker.isHidden = true
    }
}
