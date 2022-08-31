//
//  LoginProvider.swift
//  Nanameue
//
//  Created by Frqnck  on 30/08/2022.
//

import Foundation

protocol LoginProvider {
    var currentUser: User? { get }
    func performLogin(email: String, password: String, onCompletion: @escaping ((Result<User, Error>) -> Void))
    func createAccount(email: String, password: String, onCompletion: @escaping ((Result<Bool, Error>) -> Void))
}
