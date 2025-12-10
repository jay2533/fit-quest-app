//
//  Protocols.swift
//  FitQuest
//
//  Created by Sunny Yadav on 12/2/25.
//

import UIKit

protocol KeyboardProtocol {
    func hideKeyboardOnTapOutside()
}

protocol AlertProtocol {
    func showAlert(title: String, message: String)
}

protocol LoadingIndicatorProtocol {
    func showLoadingIndicator()
    func hideLoadingIndicator()
}
