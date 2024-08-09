//
//  AAZodiacSign.swift
//  astroapp
//
//  Created by Krish Mittal on 09/08/24.
//

import Foundation

struct AAZodiacSignModelName {
    static let id = "id"
    static let name = "name"
    static let imageURL = "imageURL"
    static let startDate = "startDate"
    static let endDate = "endDate"

    static let firestoreCollection = "zodiac"
}

struct AAZodiacSign: Codable, Hashable, Identifiable  {
    let id: String
    var name: String
    var imageURL: String?
    let startDate: TimeInterval
    let endDate: TimeInterval
}
