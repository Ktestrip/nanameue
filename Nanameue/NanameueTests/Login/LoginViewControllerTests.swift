//
//  LoginViewControllerTests.swift
//  NanameueTests
//
//  Created by Frqnck  on 30/08/2022.
//

import Foundation
@testable import Nanameue
import XCTest

class LoginViewControllerTests: XCTestCase {
    
    private func setupView() -> LoginViewController {
        let vc = LoginViewController(nibName: "LoginViewController", bundle: nil)
        //to trigger view will appear on vc, just add it to a view
        let view = UIView()
        view.addSubview(vc.view)
        return vc
    }
    
    func testPlaceholder() {
        let vc = self.setupView()
        XCTAssertEqual(vc.passwordTextField.placeholder, "login_password_placeholder".translate)
        XCTAssertEqual(vc.emailTextField.placeholder , "login_email_placeholder".translate)
        XCTAssertEqual(vc.connectButton.title(for: .normal), "login_connect_button".translate)
        XCTAssertEqual(vc.createAccountButton.title(for: .normal), "login_create_account_button".translate)
    }
    
    func testBackgroundColor() {
        let vc = self.setupView()
        XCTAssertEqual(vc.view.backgroundColor , UIColor(named: "mainColor"))
    }
    
    func testPasswordIsSecureEntry() {
        let vc = self.setupView()
        XCTAssertTrue(vc.passwordTextField.isSecureTextEntry)
    }
    
    func testEmailTextFieldSetup() {
        let vc = self.setupView()
        XCTAssertEqual(vc.emailTextField.autocorrectionType, .no)
        XCTAssertEqual(vc.emailTextField.spellCheckingType, .no)
        XCTAssertEqual(vc.emailTextField.keyboardType, .emailAddress)
        XCTAssertEqual(vc.emailTextField.textContentType, .emailAddress)
    }
    
    func testEmptyEmailLoginShouldNotCallLoginProvider() {
        let vc = self.setupView()
        let mock = LoginProviderMock()
        vc.loginProvider = mock
        vc.passwordTextField.text = "test"
        vc.connectButton.sendActions(for: .touchUpInside)
        XCTAssertFalse(mock.performLoginHasBeenCalled)
    }
    
    func testEmptyPasswordShouldNotCallLoginProvider() {
        let vc = self.setupView()
        let mock = LoginProviderMock()
        vc.loginProvider = mock
        vc.emailTextField.text = "test"
        vc.connectButton.sendActions(for: .touchUpInside)
        XCTAssertFalse(mock.performLoginHasBeenCalled)
    }
    
    func testShouldCallLoginProvider() {
        let vc = self.setupView()
        let mock = LoginProviderMock()
        vc.loginProvider = mock
        vc.emailTextField.text = "test"
        vc.passwordTextField.text = "test"
        // both textfield are setup, should satisfy condition for loginprovider call
        vc.connectButton.sendActions(for: .touchUpInside)
        XCTAssertTrue(mock.performLoginHasBeenCalled)
    }
    
    func testEmptyPasswordStatusLabel() {
        let vc = self.setupView()
        vc.emailTextField.text = "test@test.fr"
        // before hitting the button, label should not be visible
        XCTAssertTrue(vc.statusLabel.isHidden)
        vc.connectButton.sendActions(for: .touchUpInside)
        XCTAssertFalse(vc.statusLabel.isHidden)
        XCTAssertEqual(vc.statusLabel.textColor, UIColor(named: "error"))
        XCTAssertEqual(vc.statusLabel.text, "login_password_missing".translate)
    }
    
    
    func testEmptyEmailStatusLabel() {
        let vc = self.setupView()
        // before hitting the button, label should not be visible
        XCTAssertTrue(vc.statusLabel.isHidden)
        
        vc.connectButton.sendActions(for: .touchUpInside)
        XCTAssertFalse(vc.statusLabel.isHidden)
        XCTAssertEqual(vc.statusLabel.textColor, UIColor(named: "error"))
        XCTAssertEqual(vc.statusLabel.text, "login_email_missing".translate)
    }
}
