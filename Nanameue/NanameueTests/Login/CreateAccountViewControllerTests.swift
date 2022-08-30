//
//  CreateAccountViewControllerTests.swift
//  NanameueTests
//
//  Created by Frqnck  on 30/08/2022.
//


import Foundation
@testable import Nanameue
import XCTest
class CreateAccountViewControllerTests: XCTestCase {
    
    private func setupView() -> CreateAccountViewController {
        let vc = ViewProvider.getViewController(view: .createAccountViewController)
        //to trigger view will appear on vc, just add it to a view
        let view = UIView()
        view.addSubview(vc.view)
        return vc as! CreateAccountViewController
    }
    
    func testPlaceholder() {
        let vc = self.setupView()
        XCTAssertEqual(vc.passwordTextField.placeholder, "login_password_placeholder".translate)
        XCTAssertEqual(vc.emailTextField.placeholder , "login_email_placeholder".translate)
        XCTAssertEqual(vc.createButton.title(for: .normal), "login_create_account_button".translate)
        XCTAssertEqual(vc.passwordConfirmationTextField.placeholder, "login_password_confirm_placeholder".translate)
    }
       
    
    func testBackgroundColor() {
        let vc = self.setupView()
        XCTAssertEqual(vc.view.backgroundColor , UIColor(named: "mainColor"))
    }
    
    func testPasswordIsSecureEntry() {
        let vc = self.setupView()
        XCTAssertTrue(vc.passwordTextField.isSecureTextEntry)
        XCTAssertTrue(vc.passwordConfirmationTextField.isSecureTextEntry)
    }
    
    func testEmailTextFieldSetup() {
        let vc = self.setupView()
        XCTAssertEqual(vc.emailTextField.autocorrectionType, .no)
        XCTAssertEqual(vc.emailTextField.spellCheckingType, .no)
        XCTAssertEqual(vc.emailTextField.keyboardType, .emailAddress)
        XCTAssertEqual(vc.emailTextField.textContentType, .emailAddress)
    }
}
