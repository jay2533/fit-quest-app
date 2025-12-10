//
//  CalendarControllerAddTaskDelegate.swift
//  FitQuest
//
//  Created by Student on 12/2/25.
//

import UIKit

extension CalendarScreenViewController: AddTaskDelegate {
    func didCreateTask(_ task: FitQuestTask) {
        showAlert(title: "Success", message: "Task '\(task.title)' created successfully!")
    }
}
