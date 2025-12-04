//
//  HistoryScreenViewController.swift
//  FitQuest
//
//  Created by Student on 11/18/25.
//

import UIKit

class HistoryScreenViewController: UIViewController {

    let historyView = HistoryScreenView()
        
    // Dummy data for categories
    var categoryData: [(name: String, count: Int)] = [
        ("Mental", 24),
        ("Physical", 16),
        ("Social", 12),
        ("Creativity", 8),
        ("Miscellaneous", 20)
    ]
    
    override func loadView() {
        view = historyView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Hide navigation bar
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        // Set up table view
        historyView.categoryTableView.delegate = self
        historyView.categoryTableView.dataSource = self
        
        // Add button actions
        historyView.profileButton.addTarget(self, action: #selector(onProfileTapped), for: .touchUpInside)
        
        // Add tap gesture to logo for back navigation
        let logoTapGesture = UITapGestureRecognizer(target: self, action: #selector(onLogoTapped))
        historyView.logoImageView.addGestureRecognizer(logoTapGesture)
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    @objc func onProfileTapped() {
        // TODO: Navigate to profile screen
    }
    
    @objc func onLogoTapped() {
        navigationController?.popViewController(animated: true)
    }
        

}
