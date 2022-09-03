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

    private var posts: [Post]?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupBehavior()
        self.setupNavigationBarUI()
        self.testCreatePost()
        self.testGetPost()
        // Do any additional setup after loading the view.
    }

    private func testCreatePost() {
        let post = Post(content: "test upload")
        postProvider?.createPost(newPost: post, imageURL: nil) { res in
            switch res {
                case .success(_):
                    print("post uploaded", post.id)
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
    }

    private func testGetPost() {
        postProvider?.getPost() { res in
            switch res {
                case .success(let fetchedPost):
                    self.posts = fetchedPost.sorted(by: { $0.date > $1.date })
                    self.testDeletePost()
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
    }

    private func testDeletePost() {
        if let post = self.posts?.first {
            postProvider?.deletePost(postToDelete: post) { res in
                switch res {
                    case .success(_):
                        print("post deleted !")
                    case .failure(let err):
                        print(err)
                }
            }
        }
    }

    private func setupUI() {
        self.title = "company_name".translate
        self.tableView.backgroundColor = .yellow
        self.view.backgroundColor = UIColor(named: "mainColor")
        self.createPostButton.backgroundColor = UIColor(named: "buttonColor")
        self.createPostButton.layer.cornerRadius = self.createPostButton.frame.width / 2
        self.createPostButton.clipsToBounds = true
    }

    private func setupBehavior() {
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
        let vc = CreatePostViewController(nibName: "CreatePostViewController", bundle: nil)
        let nav = UINavigationController(rootViewController: vc)

        if let sheet = nav.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.preferredCornerRadius = 20
            sheet.prefersGrabberVisible = true
        }
        present(nav, animated: true)
    }
}

extension FeedViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
