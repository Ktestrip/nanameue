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
    private var databaseRef: DatabaseReference = Database
        .database(url: "https://nanameue-c3fe4-default-rtdb.asia-southeast1.firebasedatabase.app").reference()
    private var storageRef = Storage.storage().reference()

    func getPost() {
        // should get a list of post, missing return type
    }

    func createPost(newPost: Post, imageURL: URL?) {
        guard let url = imageURL else {
            self.savePost(post: newPost)
            return
        }
        uploadPicture(imageURL: url) { res in
            switch res {
                case .success(let url):
                    self.savePost(post: newPost, imageUrl: url)
                case .failure(_):
                    print("doomed")
            }
        }
    }

    func deletePost(postToDelete: Post) {
        // delete post based on ID
    }

    private func savePost(post: Post, imageUrl: URL? = nil) {
        // upload content of the post to realtime DB
    }

    private func uploadPicture(imageURL: URL, onCompletion: @escaping ((Result<URL, Error>) -> Void)) {
        //
        let imgRef = storageRef.child(UUID().uuidString)
        _ = imgRef.putFile(from: imageURL, metadata: nil) { metadata, error in
            guard metadata != nil else {
                onCompletion(.failure(CustomError.pictureUploadFailed(error)))
                return
            }
            imgRef.downloadURL { url, error in
                guard let downloadURL = url else {
                    onCompletion(.failure(CustomError.downloadURLFailed(error)))
                    return
                }
                onCompletion(.success(downloadURL))
            }
        }
    }
}
