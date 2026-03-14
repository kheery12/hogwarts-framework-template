import Foundation

struct User: Identifiable, Codable {
    let id: UUID
    var displayName: String?
    var areaOfInterest: Region?
    let createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case displayName = "display_name"
        case areaOfInterest = "area_of_interest"
        case createdAt = "created_at"
    }
}
