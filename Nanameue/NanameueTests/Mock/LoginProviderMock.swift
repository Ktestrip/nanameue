//
//  LoginProviderMock.swift
//  NanameueTests
//
//  Created by Frqnck  on 30/08/2022.
//

import Foundation
@testable import Nanameue

class LoginProviderMock: LoginProvider {
    var performLoginHasBeenCalled = false
    var createAccountHasBeenCalled = false
    
    func performLogin(email: String, password: String, onCompletion: @escaping ((Result<Bool, Error>) -> Void)) {
        performLoginHasBeenCalled = true
    }
    
    func createAccount(email: String, password: String, onCompletion: @escaping ((Result<Bool, Error>) -> Void)) {
        createAccountHasBeenCalled = true
    }
    
}
