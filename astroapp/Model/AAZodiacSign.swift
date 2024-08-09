//
//  AAZodiacSign.swift
//  astroapp
//
//  Created by Krish Mittal on 09/08/24.
//

import UIKit

enum ZodiacSign: String, CaseIterable {
    case aries, taurus, gemini, cancer, leo, virgo, libra, scorpio, sagittarius, capricorn, aquarius, pisces
    
    struct Info {
        let name: String
        let startDate: (month: Int, day: Int)
        let endDate: (month: Int, day: Int)
        let image: UIImage
    }
    
    var info: Info {
        switch self {
        case .aries:
            return Info(name: "Aries", startDate: (3, 21), endDate: (4, 19), image: UIImage(named: "Aries")!)
        case .taurus:
            return Info(name: "Taurus", startDate: (4, 20), endDate: (5, 20), image: UIImage(named: "Taurus")!)
        case .gemini:
            return Info(name: "Gemini", startDate: (5, 21), endDate: (6, 20), image: UIImage(named: "Gemini")!)
        case .cancer:
            return Info(name: "Cancer", startDate: (6, 21), endDate: (7, 22), image: UIImage(named: "Cancer")!)
        case .leo:
            return Info(name: "Leo", startDate: (7, 23), endDate: (8, 22), image: UIImage(named: "Leo")!)
        case .virgo:
            return Info(name: "Virgo", startDate: (8, 23), endDate: (9, 22), image: UIImage(named: "Virgo")!)
        case .libra:
            return Info(name: "Libra", startDate: (9, 23), endDate: (10, 22), image: UIImage(named: "Libra")!)
        case .scorpio:
            return Info(name: "Scorpio", startDate: (10, 23), endDate: (11, 21), image: UIImage(named: "Scorpio")!)
        case .sagittarius:
            return Info(name: "Sagittarius", startDate: (11, 22), endDate: (12, 21), image: UIImage(named: "Sagittarius")!)
        case .capricorn:
            return Info(name: "Capricorn", startDate: (12, 22), endDate: (1, 19), image: UIImage(named: "Capricorn")!)
        case .aquarius:
            return Info(name: "Aquarius", startDate: (1, 20), endDate: (2, 18), image: UIImage(named: "Aquarius")!)
        case .pisces:
            return Info(name: "Pisces", startDate: (2, 19), endDate: (3, 20), image: UIImage(named: "Pisces")!)
        }
    }
}
