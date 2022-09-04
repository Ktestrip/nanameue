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
        let vc = ViewProvider.getViewController(view: .createAccountViewController(onAccountCreated: { }))
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
        XCTAssertEqual(vc.view.backgroundColor , AssetsColor.mainColor)
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
    
    func testErrorLabelForInputMissing() {
        let vc = self.setupView()
        vc.createButton.sendActions(for: .touchUpInside)
        XCTAssertEqual(vc.errorLabel.text,"login_creation_field_missing".translate)
        XCTAssertFalse(vc.errorLabel.isHidden, "error label should be visible")
    }
    
    func testErrorWrongEmail() {
        let vc = self.setupView()
        vc.emailTextField.text = "test"
        vc.passwordTextField.text = "testTest"
        vc.passwordConfirmationTextField.text = "testTest"
        vc.createButton.sendActions(for: .touchUpInside)
        XCTAssertEqual(vc.errorLabel.text,"login_email_invalid".translate)
        XCTAssertFalse(vc.errorLabel.isHidden, "error label should be visible")
    }
    
    func testErrorLabelForPasswordTooShort() {
        let vc = self.setupView()
        vc.emailTextField.text = "test@test.fr"
        vc.passwordTextField.text = "test"
        vc.passwordConfirmationTextField.text = "test"
        vc.createButton.sendActions(for: .touchUpInside)
        XCTAssertEqual(vc.errorLabel.text,"login_password_too_short".translate)
        XCTAssertFalse(vc.errorLabel.isHidden, "error label should be visible")
    }
    
    func testErrorLabelForDifferentPassword() {
        let vc = self.setupView()
        vc.emailTextField.text = "test@test.fr"
        vc.passwordTextField.text = "testtest"
        vc.passwordConfirmationTextField.text = "testTest"
        vc.createButton.sendActions(for: .touchUpInside)
        XCTAssertEqual(vc.errorLabel.text,"login_password_different".translate)
        XCTAssertFalse(vc.errorLabel.isHidden, "error label should be visible")
    }
    
    func testErrorLabelShouldNotBeVisibleAnymore() {
        let vc = self.setupView()
        
        vc.emailTextField.text = "test@test.fr"
        vc.passwordTextField.text = "testtest"
        vc.passwordConfirmationTextField.text = "testTest"
        vc.createButton.sendActions(for: .touchUpInside)
        XCTAssertEqual(vc.errorLabel.text,"login_password_different".translate)
        XCTAssertFalse(vc.errorLabel.isHidden, "error label should be visible")
        
        //change value back to a correct one, should hide the label in the end
        vc.passwordConfirmationTextField.text = "testtest"
        vc.createButton.sendActions(for: .touchUpInside)
        XCTAssertTrue(vc.errorLabel.isHidden, "error label should not be visible")
    }
    
    func testOnAccountCreatedHasBeenCalled() {
        let vc = self.setupView()
        let expectation = self.expectation(description: #function)
        let mock = LoginProviderMock()
        mock.createAccountShouldSucceed = true
        vc.loginProvider = mock
        vc.onAccountCreated = { expectation.fulfill() }
        // before hitting the button, label should not be visible
        vc.emailTextField.text = "test@test.fr" // valid email
        vc.passwordTextField.text = "testtest"
        vc.passwordConfirmationTextField.text = "testtest"
        vc.createButton.sendActions(for: .touchUpInside)
        waitForExpectations(timeout: 0.5)
    }
}
