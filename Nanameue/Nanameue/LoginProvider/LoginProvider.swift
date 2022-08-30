//
//  LoginProvider.swift
//  Nanameue
//
//  Created by Frqnck  on 30/08/2022.
//

import Foundation

protocol LoginProvider {
    func performLogin(email: String, password: String, onCompletion: @escaping ((Result<Bool, Error>) -> Void))
    func createAccount(email: String, password: String, onCompletion: @escaping ((Result<Bool, Error>) -> Void))
}
