import Foundation

struct Fact: Identifiable, Codable, Hashable {
    let id: UUID
    let date: Date
    let region: Region
    let setNumber: Int
    let topic: String
    let title: String
    let summary: String
    let fullContent: String
    let imageUrl: String?
    let sourceUrl: String
    let createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id, date, region, topic, title, summary
        case setNumber = "set_number"
        case fullContent = "full_content"
        case imageUrl = "image_url"
        case sourceUrl = "source_url"
        case createdAt = "created_at"
    }

    var shareText: String {
        "\(title)\n\nFrom Today in History - \(region.displayName)\n\(sourceUrl)"
    }
}

// MARK: - Supabase Response Decoding

extension Fact {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(UUID.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        summary = try container.decode(String.self, forKey: .summary)
        fullContent = try container.decode(String.self, forKey: .fullContent)
        imageUrl = try container.decodeIfPresent(String.self, forKey: .imageUrl)
        sourceUrl = try container.decode(String.self, forKey: .sourceUrl)
        setNumber = try container.decode(Int.self, forKey: .setNumber)
        topic = try container.decode(String.self, forKey: .topic)

        // Decode region from string
        let regionString = try container.decode(String.self, forKey: .region)
        region = Region(rawValue: regionString) ?? .northAmerica

        // Decode dates
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withFullDate]

        let dateString = try container.decode(String.self, forKey: .date)
        date = dateFormatter.date(from: dateString) ?? Date()

        let createdAtString = try container.decode(String.self, forKey: .createdAt)
        dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        createdAt = dateFormatter.date(from: createdAtString) ?? Date()
    }
}
