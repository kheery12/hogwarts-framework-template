import Foundation
import Supabase

@MainActor
final class FavoritesService: ObservableObject {

    @Published var favorites: [Fact] = []
    @Published var isLoading = false

    private let supabase = SupabaseClient.shared

    // MARK: - Load Favorites

    func loadFavorites(for userId: UUID) async throws {
        isLoading = true
        defer { isLoading = false }

        // Join favorites with daily_facts to get full fact data
        let response: [Fact] = try await supabase
            .from(SupabaseClient.Table.favorites)
            .select("daily_facts(*)")
            .eq("user_id", value: userId)
            .order("saved_at", ascending: false)
            .execute()
            .value

        favorites = response
    }

    // MARK: - Add Favorite

    func addFavorite(userId: UUID, factId: UUID) async throws {
        let favoriteData: [String: AnyJSON] = [
            "user_id": .string(userId.uuidString),
            "fact_id": .string(factId.uuidString)
        ]

        try await supabase
            .from(SupabaseClient.Table.favorites)
            .insert(favoriteData)
            .execute()
    }

    // MARK: - Remove Favorite

    func removeFavorite(userId: UUID, factId: UUID) async throws {
        try await supabase
            .from(SupabaseClient.Table.favorites)
            .delete()
            .eq("user_id", value: userId)
            .eq("fact_id", value: factId)
            .execute()

        // Update local list
        favorites.removeAll { $0.id == factId }
    }

    // MARK: - Check if Favorited

    func isFavorited(userId: UUID, factId: UUID) async -> Bool {
        do {
            struct CountResult: Codable {
                let count: Int
            }

            let result: [CountResult] = try await supabase
                .from(SupabaseClient.Table.favorites)
                .select("count", head: true)
                .eq("user_id", value: userId)
                .eq("fact_id", value: factId)
                .execute()
                .value

            return (result.first?.count ?? 0) > 0
        } catch {
            return false
        }
    }

    // MARK: - Toggle Favorite

    func toggleFavorite(userId: UUID, fact: Fact) async throws -> Bool {
        let isFav = await isFavorited(userId: userId, factId: fact.id)

        if isFav {
            try await removeFavorite(userId: userId, factId: fact.id)
            return false
        } else {
            try await addFavorite(userId: userId, factId: fact.id)
            favorites.insert(fact, at: 0)
            return true
        }
    }
}
