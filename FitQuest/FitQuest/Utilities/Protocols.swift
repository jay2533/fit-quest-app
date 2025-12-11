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

protocol NetworkCheckable: AnyObject {
    func checkNetworkAndProceed(action: @escaping () -> Void)
    func showNoInternetAlert()
    func showOfflineBanner()
    func hideOfflineBanner()
}

extension NetworkCheckable where Self: UIViewController {
    
    func checkNetworkAndProceed(action: @escaping () -> Void) {
        if NetworkManager.shared.isConnected {
            action()
        } else {
            showNoInternetAlert()
        }
    }
    
    func showNoInternetAlert() {
        let alert = UIAlertController(
            title: "No Internet Connection",
            message: "Please check your internet connection and try again.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func showOfflineBanner() {
        view.subviews.first(where: { $0 is OfflineBannerView })?.removeFromSuperview()
        
        let banner = OfflineBannerView()
        banner.show(in: view)
    }
    
    func hideOfflineBanner() {
        if let banner = view.subviews.first(where: { $0 is OfflineBannerView }) as? OfflineBannerView {
            banner.hide()
        }
    }
}
