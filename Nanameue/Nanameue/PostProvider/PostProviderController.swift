//
//  PostProviderController.swift
//  Nanameue
//
//  Created by Frqnck  on 01/09/2022.
//

import Foundation
import FirebaseCore
import FirebaseDatabase
import Firebase
import FirebaseStorage

class PostProviderController: PostProvider {
    private var encoder = JSONEncoder()
    private var decoder = JSONDecoder()
    private lazy var databaseRef: DatabaseReference? = {
        guard let uid = Auth.auth().currentUser?.uid else {
            return nil
        }
        let ref = Database.database()
            .reference()
            .child("users/\(uid)/post")
        return ref
    }()
    private var storageRef = Storage.storage().reference()

    func getPost(onCompletion: @escaping ((Result<[Post], Error>) -> Void)) {
        //get data from realtime
        databaseRef?.queryOrderedByKey().observeSingleEvent(of: .value) { snap in
            // extract only value
            if let rawData = snap.value as? [String: Any] {
                // cast value from the array to Data
                let json = rawData.map { try? JSONSerialization.data(withJSONObject: $0.1) }
                // for each entry of json, try to decode them as Post
                let posts: [Post] = json.compactMap {
                    guard let data = $0 else {
                        onCompletion(.failure(CustomError.fetchingPostError))
                        return nil
                    }
                    let post = try? self.decoder.decode(Post.self, from: data)
                    return post
                }
                onCompletion(.success(posts))
            } else {
                onCompletion(.success([]))
            }
        }
    }

    func createPost(newPost: Post, imageURL: URL?, onCompletion: @escaping ((Result<Post, Error>) -> Void)) {
        guard let url = imageURL else {
            // if no img url, jsut create a post without picture
            self.savePost(post: newPost, onCompletion: onCompletion)
            return
        }
        // post does contains an image
        // first upload the picture
        uploadPicture(imageURL: url) { res in
            switch res {
                case .success(let url):
                    // picture was post, url point to the bucket where it is stored, we can now save the updated post
                    self.savePost(post: newPost, imageUrl: url, onCompletion: onCompletion)
                case .failure(let error):
                    onCompletion(.failure(CustomError.pictureUploadFailed(error)))
            }
        }
    }

    func deletePost(postToDelete: Post, onCompletion: @escaping ((Result<Bool, Error>) -> Void)) {
        // look for a post with same UUID and delete it
        databaseRef?.child(postToDelete.id.uuidString).removeValue() { error, _ in
            guard let error = error else {
                onCompletion(.success(true))
                return
            }
            onCompletion(.failure(CustomError.deletePostFailed(error)))
        }
    }

    private func savePost(post: Post, imageUrl: URL? = nil, onCompletion: @escaping ((Result<Post, Error>) -> Void)) {
        // if we got an url, we update the object
        if let url = imageUrl {
            post.setImageUrl(url: url)
        }
        do {
            let data = try encoder.encode(post)
            let json = try JSONSerialization.jsonObject(with: data)
            // post the object with id as key to fetch it easier
            databaseRef?.child("\(post.id.uuidString)")
                .setValue(json)
            onCompletion(.success(post))
        } catch let error {
            onCompletion(.failure(CustomError.uploadPostFailed(error)))
        }
    }

    private func uploadPicture(imageURL: URL, onCompletion: @escaping ((Result<URL, Error>) -> Void)) {
        //here we generate a random name that will be attached to the post object
        let imgRef = storageRef.child(UUID().uuidString)
        _ = imgRef.putFile(from: imageURL, metadata: nil) { metadata, error in
            guard metadata != nil else {
                //getting no metadata means something went wrong
                onCompletion(.failure(CustomError.pictureUploadFailed(error)))
                return
            }
            //try to retrieve the URL from the freshly uploaded picture
            imgRef.downloadURL { url, error in
                guard let downloadURL = url else {
                    // if URL is nil means something went wrong
                    onCompletion(.failure(CustomError.downloadURLFailed(error)))
                    return
                }
                // return the URL of the uploaded picture
                onCompletion(.success(downloadURL))
            }
        }
    }
}
