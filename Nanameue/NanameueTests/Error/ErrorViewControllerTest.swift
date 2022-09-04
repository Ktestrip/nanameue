//
//  ErrorViewControllerTest.swift
//  NanameueTests
//
//  Created by Frqnck  on 04/09/2022.
//

import Foundation
@testable import Nanameue
import XCTest

class ErrorViewControllerTest: XCTestCase {
    
    private func setupView(error: Error) -> ErrorViewController {
        let vc = ViewProvider.getViewController(view: .errorView(error: error))
        //to trigger view will appear on vc, just add it to a view
        let view = UIView()
        view.addSubview(vc.view)
        vc.viewWillAppear(true)
        return vc as! ErrorViewController
    }
    
    func testUI() {
        let vc = self.setupView(error: MockError.random)
        XCTAssertEqual(vc.errorTitleLabel.text, "error_title".translate)
        XCTAssertEqual(vc.view.backgroundColor, UIColor.clear)
        XCTAssertEqual(vc.errorContentLabel.text, MockError.random.localizedDescription)
        XCTAssertEqual(vc.errorContentView.backgroundColor, UIColor.white)
    }
}
