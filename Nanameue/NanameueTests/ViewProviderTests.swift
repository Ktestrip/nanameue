//
//  ViewProviderTests.swift
//  NanameueTests
//
//  Created by Frqnck  on 30/08/2022.
//

import Foundation
import XCTest
@testable import Nanameue

class ViewProviderTests: XCTestCase {
    
    func testLoginViewControllerConfiguration() {
        let vc = ViewProvider.getViewController(view: .loginViewController)
        guard let castedView = vc as? LoginViewController else {
            // not the good type of object
            XCTAssert(true, "viewController is not a LoginViewController")
            return
        }
        // check that login provider has been ... provided
        XCTAssertNotNil(castedView.loginProvider)
    }
    
    func testCreateAccountViewControllerConfiguration() {
        let vc = ViewProvider.getViewController(view: .createAccountViewController)
        guard let castedView = vc as? CreateAccountViewController else {
            // not the good type of object
            XCTAssert(true, "viewController is not a CreateAccountViewController")
            return
        }
        // check that login provider has been ... provided
        XCTAssertNotNil(castedView.loginProvider)
    }
}
