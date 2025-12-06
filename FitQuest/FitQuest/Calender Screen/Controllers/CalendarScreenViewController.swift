//
//  CalenderScreenViewController.swift
//  FitQuest
//
//  Created by Student on 11/17/25.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class CalendarScreenViewController: UIViewController {
    
    let calendarView = CalendarScreenView()
    var selectedDate: Date = Date()
    var currentWeekDates: [Date] = []
    
    // NEW: Real task data from Firebase
    var tasks: [FitQuestTask] = [] // Replaces dummyTasks
    private var taskListener: ListenerRegistration? // Real-time listener
    
    // ✅ Keep dummy data temporarily for reference (we'll remove this later)
    var dummyTasks: [(name: String, category: String, time: String, completion: String)] = [
        ("Read 20 pages", "Mental", "Today 5:00 PM", "1/1"),
        ("Morning run", "Physical", "Today 7:00 PM", "0/1"),
        ("Meditate", "Mental", "Tomorrow 8:00 AM", "0/1"),
        ("Good diet", "Physical", "Today", "0/2"),
        ("Daily journal", "Creativity", "Today", "1/1")
    ]
    
    // Store date picker reference
    var tempDatePicker: UIDatePicker?
    
    override func loadView() {
        view = calendarView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        // Set up table view
        calendarView.tasksTableView.delegate = self
        calendarView.tasksTableView.dataSource = self
        
        calendarView.tasksTableView.register(TaskTableViewCell.self, forCellReuseIdentifier: TaskTableViewCell.identifier)
        
        calendarView.previousWeekButton.addTarget(self, action: #selector(onPreviousWeekTapped), for: .touchUpInside)
        calendarView.nextWeekButton.addTarget(self, action: #selector(onNextWeekTapped), for: .touchUpInside)
        
        // Set up collection view
        calendarView.weekCollectionView.delegate = self
        calendarView.weekCollectionView.dataSource = self
        
        // Initialize current week
        loadCurrentWeek()
        
        // Fetch tasks for today
        fetchTasks(for: selectedDate)
        
        // Add button actions
        calendarView.profileButton.addTarget(self, action: #selector(onProfileTapped), for: .touchUpInside)
        calendarView.addTaskButton.addTarget(self, action: #selector(onAddTaskTapped), for: .touchUpInside)
        
        // Logo tap gesture
        let logoTapGesture = UITapGestureRecognizer(target: self, action: #selector(onLogoTapped))
        calendarView.logoImageView.addGestureRecognizer(logoTapGesture)
        
        // Month/Year tap gesture
        let monthTapGesture = UITapGestureRecognizer(target: self, action: #selector(onMonthYearTapped))
        calendarView.monthYearLabel.addGestureRecognizer(monthTapGesture)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // ✅ ADD THIS: Remove Firebase listener
        taskListener?.remove()
    }
    
    // MARK: - Week Management
    
    func loadCurrentWeek() {
        currentWeekDates = getWeekDates(for: selectedDate)
        calendarView.weekCollectionView.reloadData()
        updateMonthYearLabel()
        
        // Fetch tasks when week changes
        fetchTasks(for: selectedDate)
    }
    
    // MARK: - Firebase Methods

    func fetchTasks(for date: Date) {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("❌ No user logged in")
            return
        }
        
        // Remove existing listener if any
        taskListener?.remove()
        
        // ✅ Clear tasks immediately when date changes
        self.tasks = []
        DispatchQueue.main.async {
            self.calendarView.tasksTableView.reloadData()
        }
        
        let db = Firestore.firestore()
        
        // Get start and end of the selected date
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        guard let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay) else { return }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy HH:mm"
        print("\n📅 Setting up listener for date: \(dateFormatter.string(from: date))")
        print("   Range: \(dateFormatter.string(from: startOfDay)) to \(dateFormatter.string(from: endOfDay))")
        
        // Set up real-time listener
        taskListener = db.collection(Constants.Collections.tasks)
            .whereField("userId", isEqualTo: userId)
            .whereField("scheduledDate", isGreaterThanOrEqualTo: Timestamp(date: startOfDay))
            .whereField("scheduledDate", isLessThan: Timestamp(date: endOfDay))
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }
                
                if let error = error {
                    print("❌ Error fetching tasks: \(error.localizedDescription)")
                    // Clear tasks on error
                    self.tasks = []
                    DispatchQueue.main.async {
                        self.calendarView.tasksTableView.reloadData()
                    }
                    return
                }
                
                guard let snapshot = snapshot else {
                    print("⚠️ No snapshot received")
                    return
                }
                
                // Skip cache-only updates when switching dates
                if snapshot.metadata.isFromCache && snapshot.metadata.hasPendingWrites {
                    print("⏭️ Skipping cache update with pending writes")
                    return
                }
                
                // Check if this is from cache or server
                let source = snapshot.metadata.isFromCache ? "📦 CACHE" : "☁️ SERVER"
                print("\n🔄 Snapshot received [\(source)] with \(snapshot.documents.count) documents")
                
                // Log document changes
                for change in snapshot.documentChanges {
                    switch change.type {
                    case .added:
                        print("   ➕ Added: \(change.document.documentID)")
                    case .modified:
                        print("   ✏️ Modified: \(change.document.documentID)")
                    case .removed:
                        print("   ➖ Removed: \(change.document.documentID)")
                    }
                }
                
                if snapshot.documents.isEmpty {
                    print("📭 No tasks found for this date")
                    self.tasks = []
                    DispatchQueue.main.async {
                        self.calendarView.tasksTableView.reloadData()
                    }
                    return
                }
                
                // Parse documents into FitQuestTask objects
                self.tasks = snapshot.documents.compactMap { document -> FitQuestTask? in
                    let data = document.data()
                    
                    guard let userId = data["userId"] as? String,
                          let title = data["title"] as? String,
                          let categoryString = data["category"] as? String,
                          let isCustom = data["isCustom"] as? Bool,
                          let duration = data["duration"] as? Int,
                          let scheduledDateTimestamp = data["scheduledDate"] as? Timestamp,
                          let scheduledTimeTimestamp = data["scheduledTime"] as? Timestamp,
                          let notificationTimeTimestamp = data["notificationTime"] as? Timestamp,
                          let xpValue = data["xpValue"] as? Int,
                          let isCompleted = data["isCompleted"] as? Bool,
                          let createdAtTimestamp = data["createdAt"] as? Timestamp else {
                        print("⚠️ Failed to parse task: \(document.documentID)")
                        return nil
                    }
                    
                    // Log the scheduled date to verify it's in range
                    let taskDate = scheduledDateTimestamp.dateValue()
                    print("   📋 Task: \(title) - Scheduled: \(dateFormatter.string(from: taskDate))")
                    
                    // Convert category string to enum
                    let category = TaskCategory(rawValue: categoryString) ?? .miscellaneous
                    
                    // Get optional fields
                    let completedAtTimestamp = data["completedAt"] as? Timestamp
                    let notes = data["notes"] as? String
                    let imageURL = data["imageURL"] as? String
                    
                    return FitQuestTask(
                        id: document.documentID,
                        userId: userId,
                        title: title,
                        category: category,
                        isCustom: isCustom,
                        duration: duration,
                        scheduledDate: scheduledDateTimestamp.dateValue(),
                        scheduledTime: scheduledTimeTimestamp.dateValue(),
                        notificationTime: notificationTimeTimestamp.dateValue(),
                        xpValue: xpValue,
                        isCompleted: isCompleted,
                        completedAt: completedAtTimestamp?.dateValue(),
                        notes: notes,
                        imageURL: imageURL,
                        createdAt: createdAtTimestamp.dateValue()
                    )
                }
                
                // Sort tasks by scheduled time
                self.tasks.sort { $0.scheduledTime < $1.scheduledTime }
                
                print("✅ Successfully parsed \(self.tasks.count) tasks")
                
                // Reload table view on main thread
                DispatchQueue.main.async {
                    self.calendarView.tasksTableView.reloadData()
                    print("🔄 Table view reloaded with \(self.tasks.count) tasks\n")
                }
            }
    }
    
    func showEmptyState() {
        // TODO: Add empty state view
        print("📭 No tasks for this date")
    }
    
    func getWeekDates(for date: Date) -> [Date] {
        let calendar = Calendar.current
        let startOfWeek = calendar.date(
            from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date)
        )!
        
        var dates: [Date] = []
        for day in 0..<7 {
            if let date = calendar.date(byAdding: .day, value: day, to: startOfWeek) {
                dates.append(date)
            }
        }
        return dates
    }
    
    // MARK: - Actions
    
    @objc func onPreviousWeekTapped() {
        guard let newDate = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: selectedDate) else { return }
        selectedDate = newDate
        loadCurrentWeek()
        print("Previous week - now showing week of: \(selectedDate)")
    }

    @objc func onNextWeekTapped() {
        guard let newDate = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: selectedDate) else { return }
        selectedDate = newDate
        loadCurrentWeek()
        print("Next week - now showing week of: \(selectedDate)")
    }
    
    @objc func onProfileTapped() {
        print("Profile button tapped")
        // TODO: Navigate to profile screen
    }
    
    @objc func onAddTaskTapped() {
        // Check if selected date is in the past
        let startOfToday = Calendar.current.startOfDay(for: Date())
        let startOfSelected = Calendar.current.startOfDay(for: selectedDate)
        
        if startOfSelected < startOfToday {
            showAlert(
                title: "Cannot Create Task",
                message: "You cannot create tasks for past dates. You can only view completed tasks."
            )
            return
        }
        
        print("Add task button tapped - Opening Category Selection")
        
        let categorySelectionVC = CategorySelectionViewController(selectedDate: selectedDate)
        categorySelectionVC.delegate = self
        
        if let sheet = categorySelectionVC.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
        }
        
        present(categorySelectionVC, animated: true)
    }
    
    @objc func onMonthYearTapped() {
        print("Month/Year tapped - showing date picker")
        showMonthYearPicker()
    }
    
    func showMonthYearPicker() {
        let pickerVC = UIViewController()
        pickerVC.view.backgroundColor = UIColor(red: 0.08, green: 0.15, blue: 0.25, alpha: 1.0)
        
        // Title
        let titleLabel = UILabel()
        titleLabel.text = "Select Date"
        titleLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        pickerVC.view.addSubview(titleLabel)
        
        // Date picker
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .inline
        datePicker.date = selectedDate
        datePicker.tintColor = UIColor(red: 0.33, green: 0.67, blue: 0.93, alpha: 1.0)
        datePicker.overrideUserInterfaceStyle = .dark
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        pickerVC.view.addSubview(datePicker)
        
        // Store reference
        tempDatePicker = datePicker
        
        // Done button
        let doneButton = UIButton(type: .system)
        doneButton.setTitle("Done", for: .normal)
        doneButton.setTitleColor(.white, for: .normal)
        doneButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        doneButton.backgroundColor = UIColor(red: 0.33, green: 0.67, blue: 0.93, alpha: 1.0)
        doneButton.layer.cornerRadius = 25
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.addTarget(self, action: #selector(onDatePickerDone), for: .touchUpInside)
        pickerVC.view.addSubview(doneButton)
        
        // Cancel button
        let cancelButton = UIButton(type: .system)
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(.lightGray, for: .normal)
        cancelButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.addTarget(self, action: #selector(onDatePickerCancel), for: .touchUpInside)
        pickerVC.view.addSubview(cancelButton)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: pickerVC.view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: pickerVC.view.centerXAnchor),
            
            datePicker.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            datePicker.leadingAnchor.constraint(equalTo: pickerVC.view.leadingAnchor, constant: 20),
            datePicker.trailingAnchor.constraint(equalTo: pickerVC.view.trailingAnchor, constant: -20),
            
            doneButton.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 20),
            doneButton.leadingAnchor.constraint(equalTo: pickerVC.view.leadingAnchor, constant: 40),
            doneButton.trailingAnchor.constraint(equalTo: pickerVC.view.trailingAnchor, constant: -40),
            doneButton.heightAnchor.constraint(equalToConstant: 50),
            
            cancelButton.topAnchor.constraint(equalTo: doneButton.bottomAnchor, constant: 12),
            cancelButton.centerXAnchor.constraint(equalTo: pickerVC.view.centerXAnchor),
            cancelButton.bottomAnchor.constraint(lessThanOrEqualTo: pickerVC.view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
        
        if let sheet = pickerVC.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
        }
        
        present(pickerVC, animated: true)
    }

    @objc func onDatePickerDone() {
        if let datePicker = tempDatePicker {
            selectedDate = datePicker.date
            loadCurrentWeek()  // Reload week to show new week containing selected date
        }
        tempDatePicker = nil
        dismiss(animated: true)
    }

    @objc func onDatePickerCancel() {
        tempDatePicker = nil
        dismiss(animated: true)
    }
    
    func updateMonthYearLabel() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        calendarView.monthYearLabel.text = dateFormatter.string(from: selectedDate)
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    @objc func onLogoTapped() {
        print("Calendar logo tapped - going back")
        navigationController?.popViewController(animated: true)
    }
}
