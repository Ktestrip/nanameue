//
//  CreateAccountViewController.swift
//  Nanameue
//
//  Created by Frqnck  on 30/08/2022.
//

import UIKit

class CreateAccountViewController: UIViewController {
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var emailTextField: ShakableTextField!
    @IBOutlet weak var passwordTextField: ShakableTextField!
    @IBOutlet weak var passwordConfirmationTextField: ShakableTextField!
    @IBOutlet weak var createButton: UIButton!

    var loginProvider: LoginProvider?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupBehavior()
        // Do any additional setup after loading the view.
    }

    private func setupUI() {
        self.view.backgroundColor = UIColor(named: "mainColor")
        self.logoImageView.contentMode = .scaleAspectFit
        self.logoImageView.image = UIImage(named: "logo")
        self.emailTextField.placeholder = "login_email_placeholder".translate
        self.emailTextField.autocorrectionType = .no
        self.emailTextField.spellCheckingType = .no
        self.emailTextField.keyboardType = .emailAddress
        self.emailTextField.textContentType = .emailAddress
        self.passwordTextField.placeholder = "login_password_placeholder".translate
        self.passwordTextField.isSecureTextEntry = true
        self.passwordConfirmationTextField.placeholder = "login_password_confirm_placeholder".translate
        self.passwordConfirmationTextField.isSecureTextEntry = true
        self.createButton.setTitle("login_create_account_button".translate, for: .normal)
    }

    private func setupBehavior() {
        self.createButton.addTarget(self, action: #selector(self.performSignup), for: .touchUpInside)
    }

    @objc private func performSignup() {
        guard let email = extractValue(textField: self.emailTextField),
              let pass = extractValue(textField: self.passwordTextField),
              let confirm = extractValue(textField: self.passwordConfirmationTextField) else {
            return
        }
        if isValid(email: email) == false {
            return
        }
        if pass.count < 6 || confirm.count < 6 {
            self.passwordTooShort()
        }
        if pass != confirm {
            self.passwordDifferent()
        }
    }

    private func extractValue(textField: ShakableTextField) -> String? {
        guard let text = textField.text else {
            textField.shake()
            return nil
        }
        return text
    }

    private func passwordDifferent() {
        // paswword should be identical
    }

    private func passwordTooShort() {
        // should be at least 6 char long
    }

    private func isValid(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }

}
