//
//  FeedViewControllerTest.swift
//  NanameueTests
//
//  Created by Frqnck  on 31/08/2022.
//

import Foundation
@testable import Nanameue
import XCTest

class FeedViewControllerTests: XCTestCase {
    
    private func setupView() -> FeedViewController {
        let vc = ViewProvider.getViewController(view: .feedViewController)
        //to trigger view will appear on vc, just add it to a view
        // Feed view needs to be wrap into navigation controller to provide the logout button
        _ = UINavigationController(rootViewController: vc)
        let view = UIView()
        view.addSubview(vc.view)
        return vc as! FeedViewController
    }
    
 
    func testUISetup() {
        let vc = self.setupView()
        XCTAssertEqual(vc.view.backgroundColor,  AssetsColor.mainColor)
        XCTAssertEqual(vc.title, "company_name".translate)
        XCTAssertNotNil(vc.navigationController)
    }
    
    func testLogout() {
        let vc = setupView()
        let mock = LoginProviderMock()
        mock.logOutShouldSucceed = true
        vc.loginProvider = mock
        XCTAssertNotNil(vc.navigationController)
        let tapGesture = vc.navigationItem.rightBarButtonItem?.customView?.gestureRecognizers?.first
        XCTAssertNotNil(tapGesture, "tap gesture not set correctly")
        // invoke selector by its name
        vc.perform(.init(stringLiteral: "logout"))
        XCTAssertTrue(mock.logoutHasBeenCalled)
    }
}
