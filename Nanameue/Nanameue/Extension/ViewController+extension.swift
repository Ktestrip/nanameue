//
//  ViewController+extension.swift
//  Nanameue
//
//  Created by Frqnck  on 03/09/2022.
//

import Foundation
import UIKit

extension UIViewController {
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
    }

    func unregisterForKeyboardNotifications() {
        NotificationCenter.default.removeObserver(
            self,
            name: Notification.Name(UIResponder.keyboardWillHideNotification.rawValue),
            object: nil)
        NotificationCenter.default.removeObserver(
            self,
            name: Notification.Name(UIResponder.keyboardWillShowNotification.rawValue),
            object: nil)
        NotificationCenter.default.removeObserver(
            self,
            name: Notification.Name(UIResponder.keyboardDidChangeFrameNotification.rawValue),
            object: nil)
    }

    @objc open func keyboardWillShow(notification: NSNotification) {}

    @objc open func keyboardWillHide(notification: NSNotification) {}

}
