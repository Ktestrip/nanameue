//
//  LoginProviderController.swift
//  Nanameue
//
//  Created by Frqnck  on 30/08/2022.
//

import Foundation
import FirebaseAuth

class LoginProviderController: LoginProvider {
    var currentUser: User? {
        guard let user = Auth.auth().currentUser else {
            return nil
        }
        // abstract Firebase user to a custom user type
        // not to introduce firebase dependencies in other places than this file
        // make it easier for futur potential change
        return User(email: user.email ?? "", id: user.uid)
    }

    func performLogin(email: String, password: String, onCompletion: @escaping ((Result<User, Error>) -> Void)) {
        Auth.auth().signIn(withEmail: email, password: password) { userInfo, error in
            guard let error = error else {
                if let userInfo = userInfo {
                    // abstract Firebase user to a custom user type
                    // not to introduce firebase dependencies in other places than this file
                    // make it easier for futuer potential change
                    let user = User(email: userInfo.user.email ?? "", id: userInfo.user.uid)
                    onCompletion(.success(user))
                    return
                }
                // user can't be created, something wen't wrong
                return onCompletion(.failure(CustomError.userCorrupted))
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

    func logOut(onCompletion: @escaping ((Result<Bool, Error>) -> Void)) {
        do {
            try Auth.auth().signOut()
            onCompletion(.success(true))
        } catch let err {
            onCompletion(.failure(err))
        }
    }
}
