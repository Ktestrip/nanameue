//
//  PostProvider.swift
//  Nanameue
//
//  Created by Frqnck  on 01/09/2022.
//

import Foundation
import UIKit
protocol PostProvider {
    func getPost(onCompletion: @escaping ((Result<[Post], Error>) -> Void))
    func createPost(newPost: Post, imageURL: URL?, onCompletion: @escaping ((Result<Bool, Error>) -> Void))
    func deletePost(postToDelete: Post, onCompletion: @escaping ((Result<Bool, Error>) -> Void))
}
