//
//  CustomError.swift
//  Nanameue
//
//  Created by Frqnck  on 31/08/2022.
//

import Foundation

enum CustomError: Error {
    case userCorrupted
    case pictureUploadFailed(Error?)
    case downloadURLFailed(Error?)
    case fetchingPostError
    case uploadPostFailed(Error?)
    case deletePostFailed(Error?)
}
