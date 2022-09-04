//
//  String+extensions.swift
//  Nanameue
//
//  Created by Frqnck  on 30/08/2022.
//

import Foundation

extension String {
    var translate: String {
        //Look for a translation. if not translation found, return itself
        return NSLocalizedString(self, comment: "")
    }
}
