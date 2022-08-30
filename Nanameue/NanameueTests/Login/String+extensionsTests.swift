//
//  String+extensionsTests.swift
//  NanameueTests
//
//  Created by Frqnck  on 30/08/2022.
//

import Foundation
@testable import Nanameue
import XCTest

class StringExtensionsTests: XCTestCase {
    
    func testTranslationShouldNotWork() {
        XCTAssertEqual("wertyuiop".translate, "wertyuiop")
    }
    
    func testTranslationShouldWork() {
        let translation = NSLocalizedString("login_email_placeholder", comment: "")
        XCTAssertEqual("login_email_placeholder".translate, translation)
    }
}
