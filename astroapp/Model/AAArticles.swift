//
//  AAArticles.swift
//  astroapp
//
//  Created by Krish Mittal on 09/08/24.
//

import Foundation

struct AAArticlesModelName {
    static let id = "id"
    static let title = "title"
    static let content = "content"
    static let imageURL = "imageURL"
    static let created = "created"

    static let firestoreCollection = "articles"
}

struct AAArticles: Codable, Hashable, Identifiable  {
    let id: String
    var title: String
    var content: String
    var imageURL: String?
    let created: TimeInterval
}
