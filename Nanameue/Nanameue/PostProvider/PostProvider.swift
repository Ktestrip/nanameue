//
//  PostProvider.swift
//  Nanameue
//
//  Created by Frqnck  on 01/09/2022.
//

import Foundation
import UIKit
protocol PostProvider {
    func getPost()
    func createPost(newPost: Post, imageURL: URL?)
    func deletePost(postToDelete: Post)
}
