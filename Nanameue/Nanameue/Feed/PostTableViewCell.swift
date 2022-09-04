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
    private var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd, yyyy 'at' hh:mm"
        return formatter
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupUI()
        // Initialization code
    }

    private func setupUI() {
        self.containerView.backgroundColor = UIColor(named: "mainColorDarker")
        self.containerView.layer.cornerRadius = 24
        self.containerView.clipsToBounds = true
        self.imageViewHeightConstraint.constant = 0
        self.deleteButton.setImage(UIImage(named: "trashcanIcon"), for: .normal)
        self.deleteButton.setTitle("", for: .normal)
        self.backgroundColor = .clear
    }

    func setupCell(post: Post) {
        self.postImageView.image = nil
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
    }

    private func createActivityIndicator() {
        let activityIndicator = NVActivityIndicatorView(
            frame: CGRect(
                x: self.postImageView.frame.width / 2 - ((self.postImageView.frame.height * 0.7) / 2),
                y: self.postImageView.frame.height / 2 - ((self.postImageView.frame.height * 0.7) / 2),
                width: self.postImageView.frame.height * 0.7,
                height: self.postImageView.frame.height * 0.7),
            type: .circleStrokeSpin)
        self.postImageView.addSubview(activityIndicator)
        self.activityIndicatorView = activityIndicator
        self.activityIndicatorView?.startAnimating()
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
