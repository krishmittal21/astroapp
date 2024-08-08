//
//  AAUser.swift
//  astroapp
//
//  Created by Krish Mittal on 08/08/24.
//

import Foundation

struct AAUserModelName {
    static let id = "id"
    static let role = "role"
    static let email = "email"
    static let name = "name"
    static let avatarURL = "avatarURL"
    static let joined = "joined"
    static let zodiac = "zodiac"

    // Firestore collection name
    static let userFirestore = "users"
}

struct AAUser: Codable, Hashable, Identifiable {
    let id: String
    var role: String
    var email: String
    var name: String
    var avatarURL: String?
    let joined: TimeInterval
    var zodiac: String
}
