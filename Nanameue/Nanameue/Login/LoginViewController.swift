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
    @IBOutlet weak var connectButton: UIButton!
    @IBOutlet weak var createAccountButton: UIButton!
    @IBOutlet weak var logoImageView: UIImageView!
    //will be used only to keep track of login status
    @IBOutlet weak var statusLabel: UILabel!

    // login method provider
    var loginProvider: LoginProvider?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupBehavior()
        self.setupUI()
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
        self.connectButton.setTitle("login_connect_button".translate, for: .normal)
        self.createAccountButton.setTitle("login_create_account_button".translate, for: .normal)
        self.statusLabel.isHidden = true
    }

    private func setupBehavior() {
        self.connectButton.addTarget(self, action: #selector(self.onConnectButtonTap), for: .touchUpInside)
        self.createAccountButton.addTarget(self, action: #selector(self.showCreateAccountView), for: .touchUpInside)
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
        self.loginProvider?.performLogin(email: email, password: password) { res in
            switch res {
                case .success(_):
                    let feedViewController = ViewProvider.getViewController(view: .feedViewController)
                    self.navigationController?.setViewControllers([feedViewController], animated: true)
                case .failure(let error):
                    // login did fail, inform user what went wrong
                    self.setupStatusLabel(content: error.localizedDescription, isError: true)
            }
        }
    }

    private func textFieldInformationMissing(textField: ShakableTextField) {
        textField.shake()
    }

    private func setupStatusLabel(content: String, isError: Bool = false) {
        self.statusLabel.text = content
        self.statusLabel.textColor = isError ? UIColor(named: "error") : UIColor(named: "labelColor")
        self.statusLabel.isHidden = false
    }

    @objc private func showCreateAccountView() {
        let viewController = ViewProvider
            .getViewController(view: .createAccountViewController(onAccountCreated: self.onAccountCreated))
        self.present(viewController, animated: true)
    }

    private func onAccountCreated() {
        self.setupStatusLabel(content: "login_created".translate)
    }
}
