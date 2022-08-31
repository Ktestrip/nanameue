//
//  ViewProvider.swift
//  Nanameue
//
//  Created by Frqnck  on 30/08/2022.
//

import UIKit

private enum NibName: String {
    case loginViewController = "LoginViewController"
    case createAccountViewController = "CreateAccountViewController"
}

enum ViewProvider {
    enum AvailableView {
        case loginViewController
        case createAccountViewController(onAccountCreated: (() -> Void))
    }

    static func getViewController(view: ViewProvider.AvailableView) -> UIViewController {
        switch view {
            case .loginViewController:
                let nibName = NibName.loginViewController.rawValue
                let viewController = LoginViewController(nibName: nibName, bundle: nil)
                viewController.loginProvider = LoginProviderController()
                return viewController
            case .createAccountViewController(let onAccountCreated):
                let nibName = NibName.createAccountViewController.rawValue
                let viewController = CreateAccountViewController(nibName: nibName, bundle: nil)
                viewController.loginProvider = LoginProviderController()
                viewController.onAccountCreated = onAccountCreated
                return viewController

        }
    }
}
