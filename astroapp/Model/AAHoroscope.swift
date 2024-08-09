//
//  AAHoroscope.swift
//  astroapp
//
//  Created by Krish Mittal on 09/08/24.
//

import UIKit

struct AAHoroscope: Identifiable  {
    let id: String
    var name: String
    var image: horoscopeType
    var type: horoscopeType
    var when: when
}

enum when: CaseIterable {
    case today
    case tomorrow
    case week
    case month
    case year
    
    var title: String {
        switch self {
        case .today:
            return "Today"
        case .tomorrow:
            return "Tomorrow"
        case .week:
            return "Week"
        case .month:
            return "Month"
        case .year:
            return "Year"
        }
    }
}

enum horoscopeType: CaseIterable {
    case general
    case love
    case work
    case luck
    
    var title: String {
        switch self {
        case .general:
            return "General"
        case .love:
            return "Love"
        case .work:
            return "Work"
        case .luck:
            return "Luck"
        }
    }
    
    var image: UIImage {
        switch self {
        case .general:
            return UIImage(systemName: "moon.stars")!
        case .love:
            return UIImage(systemName: "heart")!
        case .work:
            return UIImage(systemName: "latch.2.case")!
        case .luck:
            return UIImage(systemName: "sparkles")!
        }
    }
}
