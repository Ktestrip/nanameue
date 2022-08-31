//
//  FeedViewControllerTest.swift
//  NanameueTests
//
//  Created by Frqnck  on 31/08/2022.
//

import Foundation
@testable import Nanameue
import XCTest

class FeedViewControllerTest: XCTestCase {
    
    private func setupView() -> FeedViewController {
        let vc = ViewProvider.getViewController(view: .feedViewController)
        //to trigger view will appear on vc, just add it to a view
        let view = UIView()
        view.addSubview(vc.view)
        return vc as! FeedViewController
    }
 
    private func testUISetup() {
        let vc = self.setupView()
        XCTAssertEqual(vc.view.backgroundColor, UIColor(named: "mainColor"))
        XCTAssertEqual(vc.title, "company_name".translate)
    }
}
