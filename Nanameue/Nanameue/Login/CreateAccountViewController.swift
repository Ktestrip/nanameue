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
    @IBOutlet weak var errorLabel: UILabel!

    var loginProvider: LoginProvider?
    // will be call once the user did create an account
    var onAccountCreated: (() -> Void)?

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
        self.errorLabel.textColor = UIColor(named: "error")
        self.errorLabel.isHidden = true
    }

    private func setupBehavior() {
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        self.passwordConfirmationTextField.delegate = self
        self.createButton.addTarget(self, action: #selector(self.prepareForSignUp), for: .touchUpInside)
        // just tap anywhere out of the keyboard to dismiss it
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }

    @objc func hideKeyboard() {
        view.endEditing(true)
    }

    @objc private func prepareForSignUp() {
        //hide keyboard
        self.resignFirstResponder()
        // check thats no fields are empty
        guard let email = extractValue(textField: self.emailTextField),
              let pass = extractValue(textField: self.passwordTextField),
              let confirm = extractValue(textField: self.passwordConfirmationTextField) else {
                self.setErrorLabel(content: "login_creation_field_missing".translate)
            return
        }
        //check that the email adress is valid
        if isValid(email: email) == false {
            self.setErrorLabel(content: "login_email_invalid".translate)
            return
        }
        //check password is at least 6 char long
        if pass.count < 6 {
            self.setErrorLabel(content: "login_password_too_short".translate)
            return
        }
        //check that both pass are identical
        if pass != confirm {
            self.setErrorLabel(content: "login_password_different".translate)
            return
        }
        self.errorLabel.isHidden = true
        self.performSignUp(email: email, password: pass)
        // now all the conditions are up to perform a signUp
    }

    private func performSignUp(email: String, password: String) {
        self.loginProvider?.createAccount(email: email, password: password) { res in
            switch res {
                case .success(_):
                    // account has been created, return to the login page
                    self.dismiss(animated: true)
                    self.onAccountCreated?()
                case .failure(let err):
                    // display error to the user
                    self.setErrorLabel(content: err.localizedDescription)
            }
        }
    }

    private func setErrorLabel(content: String) {
        self.errorLabel.isHidden = false
        self.errorLabel.text = content
    }

    private func extractValue(textField: ShakableTextField) -> String? {
        guard let text = textField.text,
              text.isEmpty == false else {
            textField.shake()
            return nil
        }
        return text
    }

    private func isValid(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}

extension CreateAccountViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
