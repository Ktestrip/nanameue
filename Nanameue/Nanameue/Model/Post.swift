//
//  Post.swift
//  Nanameue
//
//  Created by Frqnck  on 01/09/2022.
//

import Foundation
import UIKit

class Post: Identifiable, Codable {
    var id: UUID
    var content: String = ""
    var imageUrl: String?
    var date = Date()

    convenience init(content: String) {
        self.init()
        self.content = content
    }

    private init() {
        self.id = UUID()
    }

    func setImageUrl(url: URL) {
        self.imageUrl = url.absoluteString
    }

    convenience required init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        date = try container.decode(Date.self, forKey: .date)
        imageUrl = try container.decodeIfPresent(String.self, forKey: .imageUrl)
        content = try container.decode(String.self, forKey: .content)
    }
}

extension Post: Equatable {
    static func == (lhs: Post, rhs: Post) -> Bool {
        return lhs.id == rhs.id
    }
}
