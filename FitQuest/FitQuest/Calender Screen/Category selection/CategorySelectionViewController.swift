//
//  CategorySelectionViewController.swift
//  FitQuest
//
//  Created by Student on 12/4/25.
//

import UIKit

protocol CategorySelectionDelegate: AnyObject {
    func didSelectCategory(_ category: TaskCategory, selectedDate: Date)
}

class CategorySelectionViewController: UIViewController {
    
    let categoryView = CategorySelectionView()
    weak var delegate: CategorySelectionDelegate?
    var selectedDate: Date
    
    init(selectedDate: Date) {
        self.selectedDate = selectedDate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = categoryView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupActions()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func setupActions() {
        for (index, button) in categoryView.categoryButtons.enumerated() {
            button.addTarget(self, action: #selector(onCategoryTapped(_:)), for: .touchUpInside)
        }
    }
    
    @objc func onCategoryTapped(_ sender: UIButton) {
        let category = TaskCategory.allCases[sender.tag]
        print("Category selected: \(category.displayName)")
        
        dismiss(animated: true) {
            self.delegate?.didSelectCategory(category, selectedDate: self.selectedDate)
        }
    }
}
