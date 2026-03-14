import Foundation

struct WorldContext: Identifiable, Codable, Hashable {
    let id: UUID
    let factId: UUID
    let contextRegion: Region
    let eraLabel: String   // e.g. "Mid-1960s"
    let content: String    // ~150 word snapshot
    let createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case factId = "fact_id"
        case contextRegion = "context_region"
        case eraLabel = "era_label"
        case content
        case createdAt = "created_at"
    }
}

// MARK: - Supabase Response Decoding

extension WorldContext {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(UUID.self, forKey: .id)
        factId = try container.decode(UUID.self, forKey: .factId)
        eraLabel = try container.decode(String.self, forKey: .eraLabel)
        content = try container.decode(String.self, forKey: .content)

        // Decode contextRegion from string
        let regionString = try container.decode(String.self, forKey: .contextRegion)
        contextRegion = Region(rawValue: regionString) ?? .northAmerica

        // Decode createdAt date
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        let createdAtString = try container.decode(String.self, forKey: .createdAt)
        createdAt = dateFormatter.date(from: createdAtString) ?? Date()
    }
}
