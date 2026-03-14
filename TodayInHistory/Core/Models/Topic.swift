import SwiftUI

enum Topic: String, CaseIterable, Codable, Identifiable {
    case sports
    case history
    case politics
    case entertainment
    case science
    case technology
    case socialMovements = "social_movements"
    case military

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .sports: return "Sports"
        case .history: return "History"
        case .politics: return "Politics"
        case .entertainment: return "Entertainment"
        case .science: return "Science"
        case .technology: return "Technology"
        case .socialMovements: return "Social Movements"
        case .military: return "Military"
        }
    }

    var iconName: String {
        switch self {
        case .sports: return "sportscourt.fill"
        case .history: return "book.fill"
        case .politics: return "building.columns.fill"
        case .entertainment: return "film.fill"
        case .science: return "atom"
        case .technology: return "cpu.fill"
        case .socialMovements: return "person.3.fill"
        case .military: return "shield.fill"
        }
    }

    var color: Color {
        switch self {
        case .sports: return .orange
        case .history: return .brown
        case .politics: return .blue
        case .entertainment: return .pink
        case .science: return .purple
        case .technology: return .cyan
        case .socialMovements: return .green
        case .military: return .red
        }
    }
}
