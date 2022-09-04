//
//  ErrorManager.swift
//  Nanameue
//
//  Created by Frqnck  on 04/09/2022.
//

import Foundation

enum ErrorModal {
    static func dispatch(error: Error) {
        NotificationCenter.default
            .post(name: .errorInformation, object: self, userInfo: [Notification.Name.errorInformation.rawValue: error])
    }
}
