//
//  FeedViewController.swift
//  Nanameue
//
//  Created by Frqnck  on 31/08/2022.
//

import UIKit

class FeedViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var createPostButton: UIButton!

    var loginProvider: LoginProvider?
    var postProvider: PostProvider?

    private var posts: [Post] = []
    private let refreshControl = UIRefreshControl()
    private var emptyTableViewLabel: UILabel?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.registerCell()
        self.setupBehavior()
        self.setupNavigationBarUI()
        self.getPost()
    }

    private func registerCell() {
        self.tableView.register(PostTableViewCell.nib, forCellReuseIdentifier: PostTableViewCell.identifier)
    }

    @objc private func getPost() {
        // fetch users post
        postProvider?.getPost() { res in
            self.refreshControl.endRefreshing()
            switch res {
                case .success(let fetchedPost):
                    // sort result by date
                    self.posts = fetchedPost.sorted(by: { $0.date > $1.date })
                    self.tableView.reloadData()
                case .failure(let error):
                    ErrorModal.dispatch(error: error)
            }
        }
    }

    private func removePost(post: Post) {
        postProvider?.deletePost(postToDelete: post) { res in
            switch res {
                case .success(_):
                    // try to remove the newly deleted post
                    if let index = self.posts.firstIndex(of: post) {
                        self.posts.remove(at: index)
                        self.tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .bottom)
                    }
                case .failure(let error):
                    ErrorModal.dispatch(error: error)
            }
        }
    }

    private func setupUI() {
        self.title = "company_name".translate
        self.view.backgroundColor = AssetsColor.mainColor
        self.createPostButton.backgroundColor = AssetsColor.buttonColor
        self.createPostButton.layer.cornerRadius = self.createPostButton.frame.width / 2
        self.createPostButton.clipsToBounds = true
        self.tableView.backgroundColor = .clear
        self.tableView.separatorColor = .clear
        self.tableView.allowsSelection = false
    }

    private func setupBehavior() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.createPostButton.addTarget(self, action: #selector(self.openCreatePostView), for: .touchUpInside)
        self.refreshControl.addTarget(self, action: #selector(self.getPost), for: .valueChanged)
        self.tableView.addSubview(refreshControl)
    }

    private func setupNavigationBarUI() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.logout))
        let rightNavigationBarView = UIView(frame: CGRect(x: 0, y: 0, width: 36, height: 36))
        let logoutImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 36, height: 36))

        logoutImageView.image = AssetsIcon.logout
        logoutImageView.contentMode = UIView.ContentMode.scaleAspectFit
        logoutImageView.layer.masksToBounds = true
        rightNavigationBarView.addSubview(logoutImageView)
        // add custom gesture to the view to call logout func
        rightNavigationBarView.addGestureRecognizer(tapGesture)
        let rightBarButton = UIBarButtonItem(customView: rightNavigationBarView)
        self.navigationItem.rightBarButtonItem = rightBarButton
        self.navigationController?.navigationBar.backgroundColor = AssetsColor.mainColor
    }

    @objc private func logout() {
        loginProvider?.logOut { res in
            switch res {
                case .success(_):
                    // redirect to login upon logout
                    let loginViewController = ViewProvider.getViewController(view: .loginViewController)
                    self.navigationController?.setViewControllers([loginViewController], animated: true)
                case .failure(let error):
                    ErrorModal.dispatch(error: error)
            }
        }
    }

    @objc private func openCreatePostView() {
        let viewController = ViewProvider.getViewController(view: .createPostViewController { post in
            // on completion we add the newly created post into the tableview, call to getPost not needed
            self.posts.insert(post, at: 0)
            self.tableView.insertRows(at: [IndexPath(item: 0, section: 0)], with: .automatic)
        })
        let navigation = UINavigationController(rootViewController: viewController)

        if let sheet = navigation.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.preferredCornerRadius = 20
            sheet.prefersGrabberVisible = true
        }
        present(navigation, animated: true)
    }
}

extension FeedViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard self.posts.isEmpty else {
            self.emptyTableViewLabel = nil
            self.tableView.backgroundView = nil
            return self.posts.count
        }
        self.emptyTableViewLabel = UILabel(frame: CGRect(x: 0,
                                                        y: 0,
                                                        width: self.tableView.bounds.size.width,
                                                        height: self.tableView.bounds.size.height))
        self.emptyTableViewLabel?.text = "no_post".translate
        self.emptyTableViewLabel?.textAlignment = .center
        self.emptyTableViewLabel?.numberOfLines = 0
        self.tableView.backgroundView = emptyTableViewLabel
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView
            .dequeueReusableCell(withIdentifier: PostTableViewCell.identifier) as? PostTableViewCell else {
            return UITableViewCell()
        }
        cell.setupCell(post: self.posts[indexPath.row]) { post in
            self.removePost(post: post)
        }
        return cell
    }
}
