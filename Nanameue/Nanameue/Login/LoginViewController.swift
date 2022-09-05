//
//  LoginViewController.swift
//  Nanameue
//
//  Created by Frqnck  on 30/08/2022.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var passwordTextField: ShakableTextField!
    @IBOutlet weak var emailTextField: ShakableTextField!
    @IBOutlet weak var connectButton: UIAnimatedButton!
    @IBOutlet weak var createAccountButton: UIButton!
    @IBOutlet weak var logoImageView: UIImageView!
    //will be used only to keep track of login status
    @IBOutlet weak var statusLabel: UILabel!

    private var activeTextField: UITextField?
    // login method provider
    var loginProvider: LoginProvider?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupBehavior()
        self.setupUI()
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
        self.connectButton.setTitle("login_connect_button".translate, for: .normal)
        self.createAccountButton.setTitle("login_create_account_button".translate, for: .normal)
        self.statusLabel.isHidden = true

        self.configureUIButton(button: connectButton)
        self.configureUIButton(button: createAccountButton)
    }

    private func configureUIButton(button: UIButton) {
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 0.5
        button.layer.cornerRadius = 12.0
        button.clipsToBounds = true
        button.backgroundColor = AssetsColor.mainColorDark
    }

    private func setupBehavior() {
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        self.connectButton.addTarget(self, action: #selector(self.onConnectButtonTap), for: .touchUpInside)
        self.createAccountButton.addTarget(self, action: #selector(self.showCreateAccountView), for: .touchUpInside)
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }

    @objc func hideKeyboard() {
        view.endEditing(true)
    }

    @objc private func onConnectButtonTap() {
        let email = self.emailTextField.text ?? ""
        let password = self.passwordTextField.text ?? ""

        // check that both text field ar not empty
        if [email, password].allSatisfy({ $0?.isEmpty == false }) {
            self.performConnection(email: email, password: password)
        }

        // inform user which text field is not correct
        if email.isEmpty {
            self.textFieldInformationMissing(textField: self.emailTextField)
            self.setupStatusLabel(content: "login_email_missing".translate, isError: true)
            return
        }
        if password.isEmpty {
            self.textFieldInformationMissing(textField: self.passwordTextField)
            self.setupStatusLabel(content: "login_password_missing".translate, isError: true)
            return
        }
    }

    private func performConnection(email: String, password: String) {
        self.hideKeyboard()
        self.connectButton.animateActivity()
        self.loginProvider?.performLogin(email: email, password: password) { res in
            self.connectButton.stopActivity()
            switch res {
                case .success(_):
                    let feedViewController = ViewProvider.getViewController(view: .feedViewController)
                    self.navigationController?.setViewControllers([feedViewController], animated: true)
                case .failure(let error):
                    ErrorModal.dispatch(error: error)
            }
        }
    }

    private func textFieldInformationMissing(textField: ShakableTextField) {
        textField.shake()
    }

    private func setupStatusLabel(content: String, isError: Bool = false) {
        self.statusLabel.text = content
        self.statusLabel.textColor = isError ?  AssetsColor.errorColor :  AssetsColor.labelColor
        self.statusLabel.isHidden = false
    }

    @objc private func showCreateAccountView() {
        let viewController = ViewProvider
            .getViewController(view: .createAccountViewController(onAccountCreated: self.onAccountCreated))
        if let sheet = viewController.sheetPresentationController {
            sheet.detents = [.large()]
            sheet.preferredCornerRadius = 20
            sheet.prefersGrabberVisible = true
        }
        self.present(viewController, animated: true)
    }

    private func onAccountCreated() {
        self.setupStatusLabel(content: "login_created".translate)
    }
}

extension LoginViewController: UITextFieldDelegate {
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
