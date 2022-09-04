//
//  PostProviderMock.swift
//  NanameueTests
//
//  Created by Frqnck  on 04/09/2022.
//

import Foundation
@testable import Nanameue

class PostProviderMock : PostProvider {
    var postThatShouldBeReturn: Post!
    var errorToReturn: Error!
    var getPostHasBeenCalled = false
    var createPostHasBeenCalled = false
    var deletePostHasBeenCalled = false
    
    func getPost(onCompletion: @escaping ((Result<[Post], Error>) -> Void)) {
        self.getPostHasBeenCalled = true
        if let error = errorToReturn {
            onCompletion(.failure(error))
            return
        }
        onCompletion(.success([postThatShouldBeReturn]))
    }
    
    func createPost(newPost: Post, imageURL: URL?, onCompletion: @escaping ((Result<Post, Error>) -> Void)) {
        self.createPostHasBeenCalled = true
        if let error = errorToReturn {
            onCompletion(.failure(error))
            return
        }
        onCompletion(.success(postThatShouldBeReturn))
    }
    
    func deletePost(postToDelete: Post, onCompletion: @escaping ((Result<Bool, Error>) -> Void)) {
        self.deletePostHasBeenCalled = true
        if let error = errorToReturn {
            onCompletion(.failure(error))
            return
        }
        onCompletion(.success(true))
    }
    
    
}
