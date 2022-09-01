//
//  LoginProviderMock.swift
//  NanameueTests
//
//  Created by Frqnck  on 30/08/2022.
//

import Foundation
@testable import Nanameue
private enum MockError: Error {
    case random
}
class LoginProviderMock: LoginProvider {
    var currentUser: User? { return userToReturn }
    
    var userToReturn : User?
    var performLoginHasBeenCalled = false
    var createAccountHasBeenCalled = false
    var logoutHasBeenCalled = false
    var performLoginShouldSucceed = false
    var createAccountShouldSucceed = false
    var logOutShouldSucceed = false
    
    func performLogin(email: String, password: String, onCompletion: @escaping ((Result<User, Error>) -> Void)) {
        performLoginHasBeenCalled = true
        if self.performLoginShouldSucceed {
            onCompletion(.success(userToReturn!))
            return
        }
        onCompletion(.failure(MockError.random))
        
    }
    
    func createAccount(email: String, password: String, onCompletion: @escaping ((Result<Bool, Error>) -> Void)) {
        createAccountHasBeenCalled = true
        if self.createAccountShouldSucceed {
            onCompletion(.success(true))
            return
        }
        onCompletion(.failure(MockError.random))
    }
    
    func logOut(onCompletion: @escaping ((Result<Bool, Error>) -> Void)) {
        logoutHasBeenCalled = true
        if self.logOutShouldSucceed {
            onCompletion(.success(true))
            return
        }
        onCompletion(.failure(MockError.random))
    }
}
