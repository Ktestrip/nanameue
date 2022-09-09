//
//  UIAnimatedButton.swift
//  Nanameue
//
//  Created by Frqnck  on 04/09/2022.
//

import Foundation
import UIKit
import NVActivityIndicatorView

class UIAnimatedButton: UIButton {
    private var title: String = ""
    private var activityIndicatorView: NVActivityIndicatorView!

    func animateActivity(forColor: UIColor = .white) {
        self.title = self.titleLabel?.text ?? ""
        self.isUserInteractionEnabled = false
        self.setTitle("", for: .normal)
        self.setImage(nil, for: .normal)
        let activity = NVActivityIndicatorView(
            frame: CGRect(
                x: self.frame.width / 2 - ((self.frame.height * 0.7) / 2),
                y: self.frame.height / 2 - ((self.frame.height * 0.7) / 2),
                width: self.frame.height * 0.7,
                height: self.frame.height * 0.7),
            type: .circleStrokeSpin,
            color: forColor)
        self.addSubview(activity)
        self.activityIndicatorView = activity
        self.activityIndicatorView.isHidden = false
        activityIndicatorView?.startAnimating()
    }

    func stopActivity() {
        self.setTitle(title, for: .normal)
        self.removeOldActivity()
        self.isUserInteractionEnabled = true
    }

    private func removeOldActivity() {
        activityIndicatorView?.stopAnimating()
        guard let subView = activityIndicatorView else {
            return
        }
        self.willRemoveSubview(subView)
    }

    func isButtonAnimating() -> Bool? {
        return self.activityIndicatorView?.isAnimating
    }
}
