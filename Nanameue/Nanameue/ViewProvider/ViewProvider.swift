//
//  ViewProvider.swift
//  Nanameue
//
//  Created by Frqnck  on 30/08/2022.
//

import UIKit

private enum NibName: String {
    case loginViewController = "LoginViewController"
}

enum ViewProvider {
    enum AvailableView {
        case loginViewController
    }

    static func getViewController(view: ViewProvider.AvailableView) -> UIViewController {
        switch view {
            case .loginViewController:
                let nibName = NibName.loginViewController.rawValue
                let viewController = LoginViewController(nibName: nibName, bundle: nil)
                viewController.loginProvider = LoginProviderController()
                return viewController
        }
    }
}
