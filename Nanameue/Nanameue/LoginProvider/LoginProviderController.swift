//
//  LoginProviderController.swift
//  Nanameue
//
//  Created by Frqnck  on 30/08/2022.
//

import Foundation
import FirebaseAuth

class LoginProviderController: LoginProvider {
    func performLogin(email: String, password: String, onCompletion: @escaping ((Result<Bool, Error>) -> Void)) {
        Auth.auth().signIn(withEmail: email, password: password) { _, error in
            guard let error = error else {
                onCompletion(.success(true))
                return
            }
            return onCompletion(.failure(error))
        }
    }

    func createAccount(email: String, password: String, onCompletion: @escaping ((Result<Bool, Error>) -> Void)) {
        Auth.auth().createUser(withEmail: email, password: password) { _, error in
            guard let error = error else {
                onCompletion(.success(true))
                return
            }
            return onCompletion(.failure(error))
        }
    }
}
