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
    @IBOutlet weak var createButton: UIAnimatedButton!
    @IBOutlet weak var errorLabel: UILabel!

    var loginProvider: LoginProvider?
    // will be call once the user did create an account
    var onAccountCreated: (() -> Void)?

    private var activeTextField: UITextField?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupBehavior()
        self.registerForKeyboardNotifications()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.unregisterForKeyboardNotifications()
    }

    private func setupUI() {
        self.view.backgroundColor = AssetsColor.mainColor
        self.logoImageView.contentMode = .scaleAspectFit
        self.logoImageView.image = AssetsIcon.logo
        self.emailTextField.placeholder = "login_email_placeholder".translate
        self.emailTextField.autocorrectionType = .no
        self.emailTextField.spellCheckingType = .no
        self.emailTextField.keyboardType = .emailAddress
        self.emailTextField.textContentType = .emailAddress
        self.passwordTextField.placeholder = "login_password_placeholder".translate
        self.passwordTextField.isSecureTextEntry = true
        self.passwordTextField.autocorrectionType = .no
        self.passwordTextField.spellCheckingType = .no
        self.passwordConfirmationTextField.placeholder = "login_password_confirm_placeholder".translate
        self.passwordConfirmationTextField.isSecureTextEntry = true
        self.passwordConfirmationTextField.autocorrectionType = .no
        self.passwordConfirmationTextField.spellCheckingType = .no
        self.createButton.setTitle("login_create_account_button".translate, for: .normal)
        self.errorLabel.textColor = AssetsColor.errorColor
        self.errorLabel.isHidden = true

        self.createButton.layer.borderColor = UIColor.black.cgColor
        self.createButton.layer.borderWidth = 0.5
        self.createButton.layer.cornerRadius = 12.0
        self.createButton.clipsToBounds = true
        self.createButton.backgroundColor = AssetsColor.mainColorDark
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
        self.hideKeyboard()
        self.createButton.animateActivity()
        self.loginProvider?.createAccount(email: email, password: password) { res in
            self.createButton.stopActivity()
            switch res {
                case .success(_):
                    // account has been created, return to the login page
                    self.dismiss(animated: true)
                    self.onAccountCreated?()
                case .failure(let error):
                    ErrorModal.dispatch(error: error)
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
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeTextField = textField
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        self.activeTextField = nil
    }

    @objc override func keyboardWillShow(notification: NSNotification) {
        let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        guard let keyboardSize = value?.cgRectValue else {
            // if keyboard size is not available for some reason, dont do anything
            return
        }
        if let activeTextField = activeTextField {
            let bottomOfTextField = activeTextField.convert(activeTextField.bounds, to: self.view).maxY
            let topOfKeyboard = self.view.frame.height - keyboardSize.height
            // if the bottom of Textfield is below the top of keyboard, move up
            if bottomOfTextField > topOfKeyboard {
                UIView.animate(withDuration: 0.2) {
                   // make the textfield be just on top of the keyboard and add 12 just to make it a bit nicer
                    self.view.frame.origin.y = 0 - (bottomOfTextField - topOfKeyboard) - 12
                }
            }
        }
    }

    @objc override func keyboardWillHide(notification: NSNotification) {
        // move back the root view origin to zero
        self.view.frame.origin.y = 0
    }
}
