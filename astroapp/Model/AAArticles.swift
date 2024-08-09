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

extension AAArticles {
    static let examples = [
        AAArticles(
            id: "1",
            title: "Mercury Retrograde: What It Means for You",
            content: "Mercury retrograde is a phenomenon that occurs 3-4 times a year when the planet Mercury appears to move backwards in its orbit. This celestial event is known for causing communication mishaps, technology glitches, and general confusion. During this period, which typically lasts about three weeks, it's advisable to be extra cautious with important decisions, contracts, and travel plans. Many astrologers recommend using this time for reflection, review, and reorganization rather than starting new ventures. While it can be a challenging time, Mercury retrograde also offers opportunities for growth and introspection if approached mindfully.",
            imageURL: "https://images.unsplash.com/photo-1614642264762-d0a3b8bf3700",
            created: 1691625600
        ),
        AAArticles(
            id: "2",
            title: "Full Moon in Aquarius: Embrace Change",
            content: "The upcoming full moon in Aquarius brings a powerful energy of innovation and rebellion. Aquarius, an air sign ruled by Uranus, is associated with originality, humanitarianism, and unexpected changes. During this lunar phase, you may feel a strong urge to break free from restrictions and embrace your unique qualities. It's an excellent time for community activities, brainstorming sessions, and pursuing unconventional ideas. However, be mindful of potential emotional turbulence, as full moons tend to amplify our feelings. Use this cosmic energy to reflect on your place in society and how you can contribute to positive change. Remember, Aquarius encourages us to think outside the box and envision a better future for all.",
            imageURL: "https://images.unsplash.com/photo-1532693322450-2cb5c511067d",
            created: 1691712000
        ),
        AAArticles(
            id: "3",
            title: "Astrology and Career Choices: Finding Your cosmic Path",
            content: "Your zodiac sign can offer insights into your ideal career path, helping you align your professional life with your innate strengths and tendencies. For instance, fiery Aries often excels in leadership roles, while detail-oriented Virgo may find fulfillment in analytical or research-based positions. Water signs like Cancer and Pisces tend to thrive in caring professions, whereas air signs like Gemini and Libra often flourish in communication-centric careers. However, it's important to remember that astrology is just one tool for self-discovery. Your entire birth chart, including your moon sign and rising sign, can provide a more comprehensive picture. Additionally, factors like upbringing, education, and personal experiences play crucial roles in shaping your career journey. Use astrological insights as a starting point for exploration, but always trust your own instincts and passions when making important career decisions.",
            imageURL: "https://images.unsplash.com/photo-1635322966219-b75ed372eb01",
            created: 1691798400
        )
    ]
}
