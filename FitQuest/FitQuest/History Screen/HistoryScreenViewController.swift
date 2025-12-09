//
//  HistoryScreenViewController.swift
//  FitQuest
//
//  Created by Student on 11/18/25.
//


import UIKit
import FirebaseAuth
import FirebaseFirestore

class HistoryScreenViewController: UIViewController {

    let historyView = HistoryScreenView()
    
    // MARK: - Data Properties (Changed from private to internal)
    var allTasks: [FitQuestTask] = []
    var groupedTasks: [(date: Date, tasks: [FitQuestTask])] = []
    
    var selectedCategory: TaskCategory? = nil
    var isLoading = false
    var hasMoreTasks = true
    
    // Pagination
    var lastLoadedDate: Date?
    let tasksPerPage = 30 // Load 30 days at a time
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = historyView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.setNavigationBarHidden(true, animated: false)
        
        setupTableView()
        setupActions()
        
        // Load initial tasks
        loadTasks()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    // MARK: - Setup
    
    private func setupTableView() {
        historyView.tasksTableView.delegate = self
        historyView.tasksTableView.dataSource = self
    }
    
    private func setupActions() {
        historyView.filterButton.addTarget(self, action: #selector(onFilterTapped), for: .touchUpInside)
        historyView.clearFilterButton.addTarget(self, action: #selector(onClearFilterTapped), for: .touchUpInside)
        
        let logoTapGesture = UITapGestureRecognizer(target: self, action: #selector(onLogoTapped))
        historyView.logoImageView.addGestureRecognizer(logoTapGesture)
    }
    
    // MARK: - Actions
    
    @objc func onFilterTapped() {
        let filterVC = CategoryFilterViewController()
        filterVC.selectedCategory = selectedCategory
        filterVC.delegate = self
        
        if let sheet = filterVC.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
        }
        
        present(filterVC, animated: true)
    }
    
    @objc func onClearFilterTapped() {
        selectedCategory = nil
        historyView.hideFilterBadge()
        
        // Reset and reload
        allTasks = []
        groupedTasks = []
        lastLoadedDate = nil
        hasMoreTasks = true
        
        loadTasks()
    }
    
    @objc func onLogoTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Data Loading
    
    func loadTasks(isLoadingMore: Bool = false) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        guard !isLoading else { return }
        guard hasMoreTasks else { return }
        
        isLoading = true
        
        if !isLoadingMore {
            historyView.loadingIndicator.startAnimating()
        }
        
        Task {
            do {
                let tasks = try await fetchPastTasks(userId: userId, category: selectedCategory, isLoadingMore: isLoadingMore)
                
                await MainActor.run {
                    if isLoadingMore {
                        self.allTasks.append(contentsOf: tasks)
                    } else {
                        self.allTasks = tasks
                    }
                    
                    if tasks.count < self.tasksPerPage {
                        self.hasMoreTasks = false
                    }
                    
                    self.groupTasksByDate()
                    self.historyView.tasksTableView.reloadData()
                    self.historyView.loadingIndicator.stopAnimating()
                    self.isLoading = false
                    
                    print("✅ Loaded \(tasks.count) tasks (Total: \(self.allTasks.count))")
                }
                
            } catch {
                await MainActor.run {
                    self.showErrorToast("Failed to load tasks")
                    self.historyView.loadingIndicator.stopAnimating()
                    self.isLoading = false
                }
                print("❌ Error loading tasks: \(error)")
            }
        }
    }
    
    // MARK: - Firebase Fetch
    
    private func fetchPastTasks(userId: String, category: TaskCategory?, isLoadingMore: Bool) async throws -> [FitQuestTask] {
        let db = Firestore.firestore()
        
        // Calculate date range
        let now = Date()
        let endDate = lastLoadedDate ?? now
        
        let calendar = Calendar.current
        let startDate = calendar.date(byAdding: .day, value: -tasksPerPage, to: endDate) ?? endDate
        
        print("📅 Fetching tasks from \(startDate) to \(endDate)")
        if let category = category {
            print("🔍 Filtering by category: \(category.displayName)")
        }
        
        // ✅ FIXED: Build query differently based on category filter
        var query: Query
        
        if let category = category {
            // WITH CATEGORY FILTER (requires different index)
            query = db.collection(Constants.Collections.tasks)
                .whereField("userId", isEqualTo: userId)
                .whereField("category", isEqualTo: category.rawValue)
                .whereField("scheduledTime", isLessThanOrEqualTo: Timestamp(date: endDate))
                .whereField("scheduledTime", isGreaterThan: Timestamp(date: startDate))
                .order(by: "scheduledTime", descending: true)
        } else {
            // WITHOUT CATEGORY FILTER (uses existing index)
            query = db.collection(Constants.Collections.tasks)
                .whereField("userId", isEqualTo: userId)
                .whereField("scheduledTime", isLessThanOrEqualTo: Timestamp(date: endDate))
                .whereField("scheduledTime", isGreaterThan: Timestamp(date: startDate))
                .order(by: "scheduledTime", descending: true)
        }
        
        let snapshot = try await query.getDocuments()
        
        print("✅ Fetched \(snapshot.documents.count) tasks")
        
        // Update last loaded date for pagination
        if let lastTask = snapshot.documents.last {
            let data = lastTask.data()
            if let scheduledTimeTimestamp = data["scheduledTime"] as? Timestamp {
                lastLoadedDate = scheduledTimeTimestamp.dateValue()
            }
        }
        
        // Parse tasks (same as before)
        let tasks = snapshot.documents.compactMap { document -> FitQuestTask? in
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
                return nil
            }
            
            let category = TaskCategory(rawValue: categoryString) ?? .miscellaneous
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
        
        return tasks
    }
    
    // MARK: - Group Tasks by Date
    
    private func groupTasksByDate() {
        let calendar = Calendar.current
        
        // Group tasks by date (ignoring time)
        let grouped = Dictionary(grouping: allTasks) { task -> Date in
            calendar.startOfDay(for: task.scheduledDate)
        }
        
        // Sort by date (newest first)
        groupedTasks = grouped.map { (date: $0.key, tasks: $0.value) }
            .sorted { $0.date > $1.date }
        
        // Sort tasks within each date by time
        groupedTasks = groupedTasks.map { (date: $0.date, tasks: $0.tasks.sorted { $0.scheduledTime < $1.scheduledTime }) }
    }
    
    // MARK: - Helper
    
    func showErrorToast(_ message: String) {
        let toastLabel = UILabel()
        toastLabel.text = message
        toastLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        toastLabel.textColor = .white
        toastLabel.backgroundColor = UIColor.systemRed.withAlphaComponent(0.9)
        toastLabel.textAlignment = .center
        toastLabel.layer.cornerRadius = 20
        toastLabel.clipsToBounds = true
        toastLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(toastLabel)
        
        NSLayoutConstraint.activate([
            toastLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            toastLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100),
            toastLabel.widthAnchor.constraint(equalToConstant: 200),
            toastLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        toastLabel.alpha = 0
        UIView.animate(withDuration: 0.3, animations: {
            toastLabel.alpha = 1
        }) { _ in
            UIView.animate(withDuration: 0.3, delay: 1.5, options: [], animations: {
                toastLabel.alpha = 0
            }) { _ in
                toastLabel.removeFromSuperview()
            }
        }
    }
}

// MARK: - CategoryFilterDelegate

extension HistoryScreenViewController: CategoryFilterDelegate {
    func didSelectCategory(_ category: TaskCategory?) {
        selectedCategory = category
        
        if let category = category {
            historyView.showFilterBadge(categoryName: category.displayName)
        } else {
            historyView.hideFilterBadge()
        }
        
        // Reset and reload with filter
        allTasks = []
        groupedTasks = []
        lastLoadedDate = nil
        hasMoreTasks = true
        
        loadTasks()
    }
}
