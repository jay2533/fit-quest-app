//
//  StatsScreenViewController.swift
//  FitQuest
//
//  Created by Rushad Daruwalla on 11/18/25.
//

import UIKit

class StatsScreenViewController: UIViewController {
    
    let statsView = StatsScreenView()
    
    override func loadView() {
        view = statsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        let logoTap = UITapGestureRecognizer(target: self, action: #selector(onLogoTapped))
        statsView.logoImageView.addGestureRecognizer(logoTap)
        
        statsView.profileButton.addTarget(self,action: #selector(onProfileTapped),for: .touchUpInside)

    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    @objc func onProfileTapped() {
        let accountVC = ProfileViewController()
        navigationController?.pushViewController(accountVC, animated: true)
    }
    
    @objc func onLogoTapped() {
        navigationController?.popViewController(animated: true)
    }
}
