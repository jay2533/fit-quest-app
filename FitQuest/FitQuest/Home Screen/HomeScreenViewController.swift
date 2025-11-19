//
//  HomeScreenViewController.swift
//  FitQuest
//
//  Created by Rushad Daruwalla on 11/18/25.
//

import UIKit

class HomeScreenViewController: UIViewController {
    
    let homeView = HomeScreenView()
    
    // Dummy tasks (same style as CalendarScreenViewController)
    var dummyTasks: [(name: String, category: String, time: String, completion: String)] = [
        ("Read 20 pages", "Mental", "Today 5:00 PM", "1/1"),
        ("Morning run", "Physical", "Today 7:00 PM", "0/1"),
        ("Meditate", "Mental", "Tomorrow 8:00 AM", "0/1"),
        ("Good diet", "Physical", "Today", "0/2"),
        ("Daily journal", "Creativity", "Today", "1/1")
    ]
    
    override func loadView() {
        view = homeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        homeView.tasksTableView.delegate = self
        homeView.tasksTableView.dataSource = self
        
        // Card tap gestures
        let calendarTap = UITapGestureRecognizer(target: self, action: #selector(onCalendarTapped))
        homeView.calendarCardView.addGestureRecognizer(calendarTap)
        
        let historyTap = UITapGestureRecognizer(target: self, action: #selector(onTaskHistoryTapped))
        homeView.taskHistoryCardView.addGestureRecognizer(historyTap)
        
        let statsTap = UITapGestureRecognizer(target: self, action: #selector(onStatsTapped))
        homeView.statsCardView.addGestureRecognizer(statsTap)
        
        let rewardsTap = UITapGestureRecognizer(target: self, action: #selector(onRewardsTapped))
        homeView.rewardsCardView.addGestureRecognizer(rewardsTap)
        
        homeView.calendarCardView.isUserInteractionEnabled = true
        homeView.taskHistoryCardView.isUserInteractionEnabled = true
        homeView.statsCardView.isUserInteractionEnabled = true
        homeView.rewardsCardView.isUserInteractionEnabled = true
        
        homeView.notificationButton.addTarget(self, action: #selector(onNotificationsTapped), for: .touchUpInside)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    // MARK: - Navigation actions
    
    @objc func onCalendarTapped() {
        let calendarVC = CalendarScreenViewController()
        navigationController?.pushViewController(calendarVC, animated: true)
    }
    
    @objc func onTaskHistoryTapped() {
        let historyVC = HistoryScreenViewController()
        navigationController?.pushViewController(historyVC, animated: true)
    }
    
    @objc func onStatsTapped() {
        print("Stats card tapped")
        // TODO: push Stats screen when created
    }
    
    @objc func onRewardsTapped() {
        print("Rewards card tapped")
        // TODO: push Rewards screen when created
    }
    
    @objc func onNotificationsTapped() {
        print("Notifications tapped")
        // TODO: show notifications or settings
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource

extension HomeScreenViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dummyTasks.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: TaskTableViewCell.identifier,
            for: indexPath
        ) as? TaskTableViewCell else {
            return UITableViewCell()
        }
        
        let task = dummyTasks[indexPath.row]
        cell.taskNameLabel.text = task.name
        cell.categoryBadge.text = task.category
        cell.timeLabel.text = task.time
        cell.completionLabel.text = task.completion
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView,
                   estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 96
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = dummyTasks[indexPath.row]
        print("Home task tapped: \(task.name)")
        // TODO: navigate to task details
    }
}
