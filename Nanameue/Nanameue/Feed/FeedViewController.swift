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

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.registerCell()
        self.setupBehavior()
        self.setupNavigationBarUI()
        self.getPost()
        // Do any additional setup after loading the view.
    }

    private func registerCell() {
        self.tableView.register(PostTableViewCell.nib, forCellReuseIdentifier: PostTableViewCell.identifier)
    }

    private func getPost() {
        postProvider?.getPost() { res in
            switch res {
                case .success(let fetchedPost):
                    self.posts = fetchedPost.sorted(by: { $0.date > $1.date })
                    self.tableView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
    }

    private func removePost(post: Post) {
        postProvider?.deletePost(postToDelete: post) { res in
            switch res {
                case .success(_):
                    if let index = self.posts.firstIndex(of: post) {
                        self.posts.remove(at: index)
                        self.tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .bottom)
                    }
                case .failure(let err):
                    print("error -> ", err)
            }
        }
    }

    private func setupUI() {
        self.title = "company_name".translate
        self.view.backgroundColor = UIColor(named: "mainColor")
        self.createPostButton.backgroundColor = UIColor(named: "buttonColor")
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
    }

    private func setupNavigationBarUI() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.logout))
        let rightNavigationBarView = UIView(frame: CGRect(x: 0, y: 0, width: 36, height: 36))
        let logoutImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 36, height: 36))

        logoutImageView.image = UIImage(named: "logout")?.withTintColor(.white)
        logoutImageView.contentMode = UIView.ContentMode.scaleAspectFit
        logoutImageView.layer.masksToBounds = true
        rightNavigationBarView.addSubview(logoutImageView)
        // add custom gesture to the view to call logout func
        rightNavigationBarView.addGestureRecognizer(tapGesture)
        let rightBarButton = UIBarButtonItem(customView: rightNavigationBarView)
        self.navigationItem.rightBarButtonItem = rightBarButton
        self.navigationController?.navigationBar.backgroundColor = UIColor(named: "mainColor")
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @objc private func logout() {
        loginProvider?.logOut { res in
            switch res {
                case .success(_):
                    let loginViewController = ViewProvider.getViewController(view: .loginViewController)
                    self.navigationController?.setViewControllers([loginViewController], animated: true)
                case .failure(_):
                    print("woops")
            }
        }
    }

    @objc private func openCreatePostView() {
        let viewController = ViewProvider.getViewController(view: .createPostViewController { post in
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
        return self.posts.count
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
