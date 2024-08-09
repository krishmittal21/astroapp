//
//  AAHoroscope.swift
//  astroapp
//
//  Created by Krish Mittal on 09/08/24.
//

import UIKit

struct AAHoroscope: Identifiable {
    let id: String
    var zodiacSign: ZodiacSign
    var type: HoroscopeType
    var when: HoroscopePeriod
    var content: String
}

enum HoroscopeType: String, CaseIterable {
    case general, love, work, luck
    
    var title: String {
        return self.rawValue.capitalized
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

enum HoroscopePeriod: String, CaseIterable {
    case today, tomorrow, week, month, year
    
    var title: String {
        return self.rawValue.capitalized
    }
}

extension AAHoroscope {
    static let examples = [
        AAHoroscope(
            id: "1",
            zodiacSign: .aries,
            type: .general,
            when: .today,
            content: "Today is a day of new beginnings, Aries. Your natural leadership skills will be in high demand. Trust your instincts and take bold action. You may encounter some resistance, but your confidence will see you through."
        ),
        AAHoroscope(
            id: "2",
            zodiacSign: .taurus,
            type: .love,
            when: .week,
            content: "This week, Taurus, your love life takes center stage. If you're in a relationship, expect deeper connections and meaningful conversations. Single? Keep your eyes open – a potential romantic interest may appear in an unexpected place. Trust your heart, but don't rush things."
        ),
        AAHoroscope(
            id: "3",
            zodiacSign: .gemini,
            type: .work,
            when: .month,
            content: "The coming month brings exciting career opportunities, Gemini. Your communication skills will be your greatest asset. A project you've been working on may finally get the recognition it deserves. Stay flexible and be ready to adapt to new circumstances. Networking will play a crucial role in your professional growth."
        ),
        AAHoroscope(
            id: "4",
            zodiacSign: .cancer,
            type: .luck,
            when: .year,
            content: "This year, Cancer, luck is on your side in many areas of life. Financial opportunities may arise, but be sure to approach them with caution and due diligence. Your intuition will be particularly strong – trust it when making important decisions. Remember, luck favors the prepared, so stay proactive and open to new experiences."
        )
    ]
}
