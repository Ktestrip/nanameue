//
//  LoginViewController.swift
//  Nanameue
//
//  Created by Frqnck  on 30/08/2022.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var connectButton: UIButton!
    @IBOutlet weak var createAccountButton: UIButton!
    @IBOutlet weak var logoImageView: UIImageView!
    //will be used only to keep track of login status
    @IBOutlet weak var statusLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
