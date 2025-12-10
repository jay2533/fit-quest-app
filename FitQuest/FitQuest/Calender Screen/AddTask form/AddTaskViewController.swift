//
//  AddTaskViewController.swift
//  FitQuest
//
//  Created by Student on 12/2/25.
//

import UIKit

protocol AddTaskDelegate: AnyObject {
    func didCreateTask(_ task: FitQuestTask)
}

class AddTaskViewController: UIViewController {
    
    let addTaskView = AddTaskView()
    
    weak var delegate: AddTaskDelegate?
    
    var taskName: String = ""
    var selectedCategory: TaskCategory
    var selectedDate: Date
    var selectedTime: Date
    var duration: Int = 30
    var difficulty: PredefinedTask.TaskDifficulty = .medium
    var notes: String = ""
    var predefinedTask: PredefinedTask?
    var isCustomTask: Bool = true
    let durationOptions = [5, 10, 15, 20, 30, 45, 60, 90, 120, 180, 240]
    
    init(category: TaskCategory, selectedDate: Date, predefinedTask: PredefinedTask? = nil) {
        self.selectedCategory = category
        self.selectedDate = selectedDate
        self.predefinedTask = predefinedTask
        self.isCustomTask = (predefinedTask == nil)
        
        // Set default time to end of day (11:59 PM)
        var components = Calendar.current.dateComponents([.year, .month, .day], from: selectedDate)
        components.hour = 23
        components.minute = 59
        self.selectedTime = Calendar.current.date(from: components) ?? selectedDate
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = addTaskView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupInitialValues()
        setupActions()
        setupKeyboardHandling()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
        
    func setupInitialValues() {
        // If predefined task, pre-fill fields
        if let predefined = predefinedTask {
            addTaskView.taskNameTextField.text = predefined.title
            addTaskView.taskNameTextField.isEnabled = false
            addTaskView.taskNameTextField.textColor = .lightGray
            
            duration = predefined.estimatedDuration
            difficulty = predefined.difficulty
            
            // Hide difficulty control for predefined tasks
            addTaskView.difficultyLabel.isHidden = true
            addTaskView.difficultySegmentedControl.isHidden = true
        } else {
            // Custom task - show difficulty
            addTaskView.difficultyLabel.isHidden = false
            addTaskView.difficultySegmentedControl.isHidden = false
        }
        
        updateDurationButtonText()
        updateDateButtonText()
        updateTimeButtonText()
        addTaskView.datePicker.date = selectedDate
        addTaskView.timePicker.date = selectedTime
        
        if let index = durationOptions.firstIndex(of: duration) {
            addTaskView.durationPicker.selectRow(index, inComponent: 0, animated: false)
        }
    }
    
    func setupActions() {
        addTaskView.closeButton.addTarget(self, action: #selector(onCloseTapped), for: .touchUpInside)

        addTaskView.durationButton.addTarget(self, action: #selector(onDurationButtonTapped), for: .touchUpInside)

        addTaskView.durationPicker.delegate = self
        addTaskView.durationPicker.dataSource = self
        
        addTaskView.difficultySegmentedControl.addTarget(self, action: #selector(onDifficultyChanged), for: .valueChanged)
        
        addTaskView.dateButton.addTarget(self, action: #selector(onDateButtonTapped), for: .touchUpInside)
        
        addTaskView.datePicker.addTarget(self, action: #selector(onDateChanged), for: .valueChanged)
        
        addTaskView.timeButton.addTarget(self, action: #selector(onTimeButtonTapped), for: .touchUpInside)
        
        addTaskView.timePicker.addTarget(self, action: #selector(onTimeChanged), for: .valueChanged)
        
        addTaskView.createButton.addTarget(self, action: #selector(onCreateTapped), for: .touchUpInside)
        
        addTaskView.taskNameTextField.delegate = self
        
        addTaskView.notesTextView.delegate = self
    }
    
    func setupKeyboardHandling() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
        
    func updateDurationButtonText() {
        var config = addTaskView.durationButton.configuration
        config?.title = "\(duration) minutes"
        addTaskView.durationButton.configuration = config
    }
    
    func updateDateButtonText() {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        let dateString = formatter.string(from: selectedDate)
        
        let isToday = Calendar.current.isDateInToday(selectedDate)
        let displayText = isToday ? "\(dateString) (Today)" : dateString
        
        var config = addTaskView.dateButton.configuration
        config?.title = displayText
        addTaskView.dateButton.configuration = config
    }
    
    func updateTimeButtonText() {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        let timeString = formatter.string(from: selectedTime)
        
        var config = addTaskView.timeButton.configuration
        config?.title = timeString
        addTaskView.timeButton.configuration = config
    }
    
    func calculateNotificationTime() -> Date {
        return Calendar.current.date(
            byAdding: .minute,
            value: -15,
            to: selectedTime
        ) ?? selectedTime
    }
    
    func calculateXP() -> Int {
        if let predefined = predefinedTask {
            // Use predefined XP value
            return predefined.defaultXPValue
        } else {
            // Custom task: calculate based on duration and difficulty
            return Constants.XP.calculateXP(duration: duration, difficulty: difficulty)
        }
    }
        
    @objc func onCloseTapped() {
        dismiss(animated: true)
    }
    
    @objc func onDurationButtonTapped() {
        addTaskView.durationPickerVisible.toggle()
        
        if addTaskView.durationPickerVisible {
            addTaskView.showDurationPicker()
        } else {
            addTaskView.hideDurationPicker()
        }
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func onDifficultyChanged() {
        switch addTaskView.difficultySegmentedControl.selectedSegmentIndex {
        case 0:
            difficulty = .easy
        case 1:
            difficulty = .medium
        case 2:
            difficulty = .hard
        default:
            difficulty = .medium
        }
    }
    
    @objc func onDateButtonTapped() {
        addTaskView.datePickerVisible.toggle()
        
        if addTaskView.datePickerVisible {
            addTaskView.showDatePicker()
        } else {
            addTaskView.hideDatePicker()
        }
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func onDateChanged() {
        selectedDate = addTaskView.datePicker.date
        updateDateButtonText()
    }
    
    @objc func onTimeButtonTapped() {
        addTaskView.timePickerVisible.toggle()
        
        if addTaskView.timePickerVisible {
            addTaskView.showTimePicker()
        } else {
            addTaskView.hideTimePicker()
        }
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func onTimeChanged() {
        selectedTime = addTaskView.timePicker.date
        updateTimeButtonText()
    }
    
    @objc func onCreateTapped() {
        if validateForm() {
            createTask()
        }
    }
        
    func validateForm() -> Bool {
        // 1. Task name not empty
        taskName = addTaskView.taskNameTextField.text?.trimmingCharacters(in: .whitespaces) ?? ""
        guard !taskName.isEmpty else {
            showAlert(title: "Error", message: "Please enter a task name")
            return false
        }
        
        // 2. Duration must be valid
        guard duration >= Constants.Defaults.minTaskDuration && duration <= Constants.Defaults.maxTaskDuration else {
            showAlert(title: "Error", message: "Duration must be between \(Constants.Defaults.minTaskDuration) and \(Constants.Defaults.maxTaskDuration) minutes")
            return false
        }
        
        // 3. Date not in the past (unless today)
        if !Calendar.current.isDateInToday(selectedDate) {
            let startOfToday = Calendar.current.startOfDay(for: Date())
            let startOfSelected = Calendar.current.startOfDay(for: selectedDate)
            guard startOfSelected >= startOfToday else {
                showAlert(title: "Error", message: "Cannot create tasks in the past")
                return false
            }
        }
        
        return true
    }
    
    func createTask() {
        guard let userId = AuthService.shared.currentUserId else {
            showAlert(title: "Error", message: "Please sign in to create tasks")
            return
        }
        
        notes = addTaskView.notesTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let notificationTime = calculateNotificationTime()
        
        let xpValue = calculateXP()
        
        let task = FitQuestTask(
            userId: userId,
            title: taskName,
            category: selectedCategory,
            isCustom: isCustomTask,
            duration: duration,
            scheduledDate: selectedDate,
            scheduledTime: selectedTime,
            notificationTime: notificationTime,
            xpValue: xpValue,
            isCompleted: false,
            completedAt: nil,
            notes: notes.isEmpty ? nil : notes,
            imageURL: nil,
            createdAt: Date()
        )
        
        saveTaskToFirebase(task)
    }
    
    func saveTaskToFirebase(_ task: FitQuestTask) {
        addTaskView.createButton.isEnabled = false
        addTaskView.createButton.setTitle("Creating...", for: .normal)
        
        Task {
            do {
                let taskId = try await TaskService.shared.createTask(task)
                
                await MainActor.run {
                    print("Task created with ID: \(taskId)")
                    print("  Title: \(task.title)")
                    print("  Category: \(task.category.displayName)")
                    print("  Duration: \(task.duration) min")
                    print("  XP Value: \(task.xpValue)")
                    print("  Scheduled: \(task.scheduledDate)")
                    
                    // Create task copy with ID for delegate
                    var taskWithId = task
                    taskWithId.id = taskId
                    
                    // Pass task to delegate
                    delegate?.didCreateTask(taskWithId)
                    
                    // Dismiss modal
                    dismiss(animated: true)
                }
            } catch {
                await MainActor.run {
                    addTaskView.createButton.isEnabled = true
                    addTaskView.createButton.setTitle("Create Task", for: .normal)
                    
                    showAlert(title: "Error", message: "Failed to create task: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        addTaskView.scrollView.contentInset = contentInsets
        addTaskView.scrollView.scrollIndicatorInsets = contentInsets
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        addTaskView.scrollView.contentInset = .zero
        addTaskView.scrollView.scrollIndicatorInsets = .zero
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}


extension AddTaskViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return durationOptions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(durationOptions[row]) minutes"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        duration = durationOptions[row]
        updateDurationButtonText()
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let title = "\(durationOptions[row]) minutes"
        return NSAttributedString(
            string: title,
            attributes: [.foregroundColor: UIColor.white]
        )
    }
}

extension AddTaskViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension AddTaskViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = ""
            textView.textColor = .white
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.textColor = .lightGray
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
        return updatedText.count <= 200
    }
}
