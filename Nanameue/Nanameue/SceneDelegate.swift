//
//  SceneDelegate.swift
//  Nanameue
//
//  Created by Frqnck  on 29/08/2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        var rootViewController: UIViewController!
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene

        if  LoginProviderController().currentUser != nil {
            rootViewController = ViewProvider.getViewController(view: .feedViewController)
        } else {
            rootViewController = ViewProvider.getViewController(view: .loginViewController)
        }
        let navigation = UINavigationController(rootViewController: rootViewController)
        window?.rootViewController = navigation
        window?.makeKeyAndVisible()
        //register for error gesture
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleError),
                                               name: .errorInformation,
                                               object: nil)
    }

    @objc private func handleError(_ notification: Notification) {
        guard let content = notification.userInfo?[Notification.Name.errorInformation.rawValue] as? Error else {
            return
        }
        DispatchQueue.main.async {
            guard let errorViewController = ViewProvider
                .getViewController(view: .errorView(error: content)) as? ErrorViewController else {
                return
            }

            var topViewController = UIApplication.shared.windows.first?.rootViewController
            while let viewController = topViewController?.presentedViewController {
                topViewController = viewController
            }
            if let sheet = errorViewController.sheetPresentationController {
                sheet.detents = [.medium() ]
                sheet.preferredCornerRadius = 20
                sheet.prefersGrabberVisible = true
            }
            topViewController?.present(errorViewController, animated: true, completion: nil)
        }
    }
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
}
