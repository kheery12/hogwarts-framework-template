import SwiftUI

enum Region: String, CaseIterable, Codable, Identifiable {
    case northAmerica = "north_america"
    case europe = "europe"
    case asia = "asia"
    case africa = "africa"
    case southAmerica = "south_america"

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .northAmerica: return "North America"
        case .europe: return "Europe"
        case .asia: return "Asia"
        case .africa: return "Africa"
        case .southAmerica: return "South America"
        }
    }

    var iconName: String {
        switch self {
        case .northAmerica: return "globe.americas.fill"
        case .europe: return "globe.europe.africa.fill"
        case .asia: return "globe.asia.australia.fill"
        case .africa: return "globe.europe.africa.fill"
        case .southAmerica: return "globe.americas.fill"
        }
    }

    var color: Color {
        switch self {
        case .northAmerica: return Color.theme.northAmerica
        case .europe: return Color.theme.europe
        case .asia: return Color.theme.asia
        case .africa: return Color.theme.africa
        case .southAmerica: return Color.theme.southAmerica
        }
    }

    var placeholderImageName: String {
        switch self {
        case .northAmerica: return "placeholder_na"
        case .europe: return "placeholder_eu"
        case .asia: return "placeholder_as"
        case .africa: return "placeholder_af"
        case .southAmerica: return "placeholder_sa"
        }
    }
}
