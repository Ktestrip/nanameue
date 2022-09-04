//
//  ErrorViewController.swift
//  Nanameue
//
//  Created by Frqnck  on 04/09/2022.
//

import UIKit

class ErrorViewController: UIViewController {
    @IBOutlet weak var errorContentView: UIView!
    @IBOutlet weak var errorContentLabel: UILabel!
    @IBOutlet weak var errorTitleLabel: UILabel!

    var error: Error?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupError()
    }

    private func setupUI() {
        self.view.backgroundColor = .clear
        self.errorContentView.backgroundColor = .white
        self.errorTitleLabel.text = "error_title".translate
        self.errorContentView.layer.cornerRadius = 24.0
        self.errorContentView.clipsToBounds = true
        self.errorTitleLabel.textColor = .black
        self.errorContentLabel.textColor = .black
    }

    private func setupError() {
        guard let error = error else {
            return
        }
        self.errorContentLabel.text = error.localizedDescription
        // view will resign after showig up for 5 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            self.dismiss(animated: true)
        }
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
