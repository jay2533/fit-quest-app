//
//  LandingViewController.swift
//  FitQuest
//
//  Created by Sunny Yadav on 11/17/25.
//

import UIKit

class LandingViewController: UIViewController {
    
    let landingView = LandingView()
    
    override func loadView() {
        view = landingView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        landingView.signUpButton.addTarget(self, action: #selector(onSignUpTapped), for: .touchUpInside)
        landingView.logInButton.addTarget(self, action: #selector(onLogInTapped), for: .touchUpInside)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc func onSignUpTapped() {
        // TODO: Navigate to Sign Up screen
         let registerVC = RegisterViewController()
         navigationController?.pushViewController(registerVC, animated: true)
    }
    
    @objc func onLogInTapped() {
        // TODO: Navigate to Log In screen
         let loginVC = ViewController()
         navigationController?.pushViewController(loginVC, animated: true)
    }
}
