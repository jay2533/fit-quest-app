//
//  CalenderScreenViewController.swift
//  FitQuest
//
//  Created by Student on 11/17/25.
//

import UIKit

class CalendarScreenViewController: UIViewController {
    
    let calendarView = CalendarScreenView()
    var selectedDate: Date = Date()
    var currentWeekDates: [Date] = []
    
    // Dummy data for tasks
    var dummyTasks: [(name: String, category: String, time: String, completion: String)] = [
        ("Read 20 pages", "Mental", "Today 5:00 PM", "1/1"),
        ("Morning run", "Physical", "Today 7:00 PM", "0/1"),
        ("Meditate", "Mental", "Tomorrow 8:00 AM", "0/1"),
        ("Good diet", "Physical", "Today", "0/2"),
        ("Daily journal", "Creativity", "Today", "1/1")
    ]
    
    override func loadView() {
        view = calendarView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hide navigation bar for this screen
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        // Set up table view
        calendarView.tasksTableView.delegate = self
        calendarView.tasksTableView.dataSource = self
        
        // Set up collection view
        calendarView.weekCollectionView.delegate = self
        calendarView.weekCollectionView.dataSource = self
        
        // Initialize current week
        loadCurrentWeek()
        
        // Add button actions
        calendarView.profileButton.addTarget(self, action: #selector(onProfileTapped), for: .touchUpInside)
        calendarView.previousWeekButton.addTarget(self, action: #selector(onPreviousWeekTapped), for: .touchUpInside)
        calendarView.nextWeekButton.addTarget(self, action: #selector(onNextWeekTapped), for: .touchUpInside)
        calendarView.addTaskButton.addTarget(self, action: #selector(onAddTaskTapped), for: .touchUpInside)
        
        let logoTapGesture = UITapGestureRecognizer(target: self, action: #selector(onLogoTapped))
            calendarView.logoImageView.addGestureRecognizer(logoTapGesture)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    func loadCurrentWeek() {
        currentWeekDates = getWeekDates(for: selectedDate)
        calendarView.weekCollectionView.reloadData()
        updateMonthYearLabel()
    }
    
    func getWeekDates(for date: Date) -> [Date] {
        let calendar = Calendar.current
        let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date))!
        
        var dates: [Date] = []
        for day in 0..<7 {
            if let date = calendar.date(byAdding: .day, value: day, to: startOfWeek) {
                dates.append(date)
            }
        }
        return dates
    }
    

    @objc func onProfileTapped() {
        // TODO: Navigate to profile screen
    }
    
    @objc func onPreviousWeekTapped() {
        // TODO: Navigate to previous week
        guard let newDate = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: selectedDate) else { return }
        selectedDate = newDate
        updateMonthYearLabel()
    }
    
    @objc func onNextWeekTapped() {
        // TODO: Navigate to next week
        guard let newDate = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: selectedDate) else { return }
        selectedDate = newDate
        updateMonthYearLabel()
    }
    
    @objc func onAddTaskTapped() {
        // TODO: change navigation, right now just for testing
//        let historyVC = HistoryScreenViewController()
//        navigationController?.pushViewController(historyVC, animated: true)
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
        navigationController?.popViewController(animated: true)
    }
}
