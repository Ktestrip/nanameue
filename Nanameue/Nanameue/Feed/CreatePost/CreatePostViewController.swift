//
//  CreatePostViewController.swift
//  Nanameue
//
//  Created by Frqnck  on 02/09/2022.
//

import UIKit
import PhotosUI

class CreatePostViewController: UIViewController {
    @IBOutlet weak var openPhotoButton: UIButton!
    @IBOutlet weak var sharePostButton: UIAnimatedButton!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var imageContainerView: UIView!
    @IBOutlet weak var imageContainerHeight: NSLayoutConstraint!
    @IBOutlet weak var textViewContainer: UIView!
    @IBOutlet weak var postTextView: UITextView!

    private var placeholderLabel: UILabel!
    private var removePictureButton: UIButton!
    private var imageURL: URL?

    var onPostCreated: ((Post) -> Void)?
    var postProvider: PostProvider?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupPlaceholder()
        self.setupRemovePictureButton()
        self.setupBehavior()
        // Do any additional setup after loading the view.
    }

    private func setupUI() {
        self.applyRadiusOf(24.0, forView: self.textViewContainer)
        self.applyRadiusOf(24.0, forView: self.imageContainerView)
        self.applyRadiusOf(12.0, forView: self.openPhotoButton)
        self.applyRadiusOf(12.0, forView: self.sharePostButton)

        self.imageContainerView.backgroundColor = AssetsColor.mainColorDark
        self.openPhotoButton.backgroundColor = AssetsColor.mainColorDark
        self.postTextView.backgroundColor = AssetsColor.mainColorDark
        self.textViewContainer.backgroundColor = AssetsColor.mainColorDark
        self.sharePostButton.backgroundColor = AssetsColor.mainColorDark
        self.postImageView.backgroundColor = AssetsColor.mainColorDark

        self.sharePostButton.setTitle("create_disable_share_button".translate, for: .disabled)
        self.sharePostButton.setTitle("create_share_post".translate, for: .normal)
        self.openPhotoButton.setTitle("create_add_picture".translate, for: .normal)

        self.sharePostButton.layer.borderColor = UIColor.black.cgColor
        self.sharePostButton.layer.borderWidth = 0.5

        self.openPhotoButton.layer.borderColor = UIColor.black.cgColor
        self.openPhotoButton.layer.borderWidth = 0.5

        self.imageContainerHeight.constant = 0
    }

    private func setupPlaceholder() {
        let pointSize = postTextView.font?.pointSize ?? 0
        self.placeholderLabel = UILabel()
        self.placeholderLabel.text = "create_text_placeholder".translate
        self.placeholderLabel.font = .italicSystemFont(ofSize: pointSize)
        self.placeholderLabel.sizeToFit()
        self.postTextView.addSubview(placeholderLabel)
        self.placeholderLabel.frame.origin = CGPoint(x: 6, y: pointSize / 2)
        self.placeholderLabel.textColor = .tertiaryLabel
        self.placeholderLabel.isHidden = !postTextView.text.isEmpty
    }

    private func setupRemovePictureButton() {
        self.removePictureButton = UIButton(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        self.removePictureButton.layer.cornerRadius = self.removePictureButton.frame.height / 2
        self.removePictureButton.backgroundColor = .white
        self.removePictureButton.setBackgroundImage(AssetsIcon.closeIcon, for: .normal)
    }

    private func setupBehavior() {
        self.openPhotoButton.addTarget(self, action: #selector(self.checkLibraryPermission), for: .touchUpInside)
        self.sharePostButton.addTarget(self, action: #selector(self.sharePost), for: .touchUpInside)
        self.removePictureButton.addTarget(self, action: #selector(self.removePicture), for: .touchUpInside)
        self.postTextView.delegate = self
        self.sharePostButton.isEnabled = false
        self.presentationController?.delegate = self
        self.navigationController?.presentationController?.delegate = self
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }

    @objc func hideKeyboard() {
        view.endEditing(true)
    }

    private func applyRadiusOf(_ size: CGFloat, forView: UIView) {
        forView.layer.cornerRadius = size
        forView.clipsToBounds = true
    }

    private func resizeDetent(detent: UISheetPresentationController.Detent.Identifier) {
        if let sheet = self.sheetPresentationController {
            sheet.animateChanges {
                sheet.selectedDetentIdentifier = detent
            }
        }
    }

    private func addRemovePictureButton() {
        //by picking those value we end upp having the buton place a but off of the upper right of the view

        /*
        * |-----------------X  <-- here
        * |                 |
        * |                 |
        * |-----------------|
        */

        let xPoint = self.imageContainerView.frame.width +
                    self.imageContainerView.frame.origin.x -
                    self.removePictureButton.frame.width / 1.5
        let yPoint = self.imageContainerView.frame.origin.y - self.removePictureButton.frame.height / 3
        self.removePictureButton.frame.origin = CGPoint(x: xPoint, y: yPoint)
        self.view.addSubview(removePictureButton)
    }

    @objc private func removePicture() {
        self.postImageView.image = nil
        self.updateShareButtonEnabling()
        self.changeImagecontainerConstraints()
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }

    @objc private func sharePost() {
        let post = Post(content: self.postTextView.text)
        self.sharePostButton.animateActivity()
        self.globalInteraction(enable: false)
        self.postProvider?.createPost(newPost: post, imageURL: self.imageURL) { [weak self] res in
            // only good reason to capture self here, is that the user could dismiss the view before the end of the call
            // if such thing happen, self might be de init
            guard let self = self else {
                return
            }
            self.sharePostButton.stopActivity()
            self.globalInteraction(enable: true)
            switch res {
                case .success(let post):
                    self.onPostCreated?(post)
                    self.dismiss(animated: true)
                case .failure(let error):
                    ErrorModal.dispatch(error: error)
            }
        }
    }

    // disable any possible interaction with the view
    private func globalInteraction(enable: Bool) {
        self.removePictureButton.isEnabled = enable
        self.postTextView.isEditable = enable
        self.openPhotoButton.isEnabled = enable
    }

    private func changeImagecontainerConstraints() {
        guard self.imageContainerHeight.constant == 0 else {
            self.sharePostButton.isEnabled = !self.postTextView.text.isEmpty
            self.removePictureButton.removeFromSuperview()
            self.imageContainerHeight.constant = 0
            return
        }
        self.sharePostButton.isEnabled = true
        self.imageContainerHeight.constant = self.view.frame.height / 6
        self.addRemovePictureButton()
        return
    }

    // MARK: - library access methods

    @objc private func openLibrary() {
        DispatchQueue.main.async {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            if let sheet = imagePicker.sheetPresentationController {
                sheet.detents = [.medium()]
            }
            self.resizeDetent(detent: .large)
            self.present(imagePicker, animated: true)
        }
    }

    @objc private func checkLibraryPermission() {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAuthorizationStatus {
            case .authorized:
                self.openLibrary()
                return
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization { status in
                    if status == PHAuthorizationStatus.authorized {
                        self.openLibrary()
                        return
                    }
                }
            default:
                self.redirectToSettingDialog()
        }
    }

    private func redirectToSettingDialog() {
        let actionSheet = UIAlertController(title: "create_need_access_library_title".translate,
                                            message: "create_need_access_library_content".translate,
                                            preferredStyle: .actionSheet)
        let settingsRedirect = UIAlertAction(title: "create_settings_redirect".translate,
                                                  style: .default) { _ in
            // Open app privacy settings
            self.redirectToSettings()
        }
        actionSheet.addAction(settingsRedirect)
        let cancelAction = UIAlertAction(title: "cancel".translate, style: .cancel, handler: nil)
        actionSheet.addAction(cancelAction)
        self.present(actionSheet, animated: true, completion: nil)
    }

    private func redirectToSettings() {
        // Open app privacy settings
        guard let url = URL(string: UIApplication.openSettingsURLString),
              UIApplication.shared.canOpenURL(url) else {
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }

    private func updateShareButtonEnabling() {
        sharePostButton.isEnabled = !self.postTextView.text.isEmpty || self.postImageView.image != nil
    }
}

extension CreatePostViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[.originalImage] as? UIImage {
            self.postImageView.image = image
            self.imageURL = info[.imageURL] as? URL
            self.changeImagecontainerConstraints()
            UIView.animate(withDuration: 0.2) {
                self.view.layoutIfNeeded()
            }
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

extension CreatePostViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
        self.updateShareButtonEnabling()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension CreatePostViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
        return !(self.sharePostButton.isButtonAnimating() ?? false)
    }
}
