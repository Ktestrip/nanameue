//
//  PostTableViewCell.swift
//  Nanameue
//
//  Created by Frqnck  on 04/09/2022.
//

import UIKit
import Kingfisher
import NVActivityIndicatorView
class PostTableViewCell: UITableViewCell {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    private var activityIndicatorView: NVActivityIndicatorView?
    private var onDelete: ((Post) -> Void)?
    private var post: Post?
    private var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd, yyyy '-' hh:mm"
        return formatter
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupUI()
        // Initialization code
    }

    private func setupUI() {
        self.containerView.backgroundColor = AssetsColor.mainColorDark
        self.containerView.layer.cornerRadius = 24
        self.containerView.clipsToBounds = true
        self.imageViewHeightConstraint.constant = 0
        self.deleteButton.setImage(AssetsIcon.trashIcon, for: .normal)
        self.deleteButton.setTitle("", for: .normal)
        self.backgroundColor = .clear
    }

    func setupCell(post: Post, onDelete: @escaping ((Post) -> Void)) {
        self.post = post
        self.onDelete = onDelete
        self.postImageView.image = nil
        //remove possible activity indicator that could still be visible
        self.postImageView.subviews.forEach { $0.removeFromSuperview() }
        // if cell is reused and previous cell add constraints up for image view, constant will still be 128
        self.imageViewHeightConstraint.constant = 0
        self.contentLabel.text = post.content
        self.dateLabel.text = dateFormatter.string(from: post.date)
        if let stringUrl = post.imageUrl {
            // image will be async downloaded. display activity indicator during download
            let url = URL(string: stringUrl)
            self.createActivityIndicator()
            self.postImageView.kf.setImage(with: url) { _ in
                // image has been downloaded, error or not, activity indicator needs to be remove
                self.removeActivityIndicator()
            }
            // update constraints to make imageview visible
            self.imageViewHeightConstraint.constant = 128
            UIView.animate(withDuration: 0.2) {
                self.layoutIfNeeded()
            }
        }
        self.deleteButton.addTarget(self, action: #selector(self.onDeleteButtonTap), for: .touchUpInside)
        self.layoutIfNeeded()
    }

    private func createActivityIndicator() {
        let activityIndicator = NVActivityIndicatorView(
            frame: CGRect(
                x: 0,
                y: 0,
                width: self.postImageView.frame.height * 0.4,
                height: self.postImageView.frame.height * 0.4),
            type: .circleStrokeSpin)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.postImageView.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: self.postImageView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: self.postImageView.centerYAnchor)
        ])
        self.activityIndicatorView = activityIndicator
        self.activityIndicatorView?.startAnimating()
    }

    @objc private func onDeleteButtonTap() {
        guard let post = self.post else {
            return
        }
        self.onDelete?(post)
    }

    private func removeActivityIndicator() {
        self.activityIndicatorView?.stopAnimating()
        self.activityIndicatorView?.removeFromSuperview()
        self.activityIndicatorView = nil
    }
}

extension PostTableViewCell: IdentifiableCell {
    static var identifier: String = "PostTableViewCell"
    static var nib = UINib(nibName: "PostTableViewCell", bundle: nil)
}
