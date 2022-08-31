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
    var performLoginHasBeenCalled = false
    var createAccountHasBeenCalled = false
    var performLoginShouldSucceed = false
    var createAccountShouldSucceed = false
    
    func performLogin(email: String, password: String, onCompletion: @escaping ((Result<Bool, Error>) -> Void)) {
        performLoginHasBeenCalled = true
        if self.performLoginShouldSucceed {
            onCompletion(.success(true))
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
    
}
