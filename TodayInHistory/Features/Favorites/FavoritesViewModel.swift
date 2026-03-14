import Foundation

@MainActor
final class FavoritesViewModel: ObservableObject {

    @Published var favorites: [Fact] = []
    @Published var isLoading = false
    @Published var error: Error?

    private let favoritesService = FavoritesService()

    // MARK: - Load Favorites

    func loadFavorites(userId: UUID?) async {
        guard let userId = userId else {
            favorites = []
            return
        }

        isLoading = true
        error = nil

        do {
            try await favoritesService.loadFavorites(for: userId)
            favorites = favoritesService.favorites
        } catch {
            self.error = error
            Logger.log("Failed to load favorites: \(error)", level: .error)
        }

        isLoading = false
    }

    // MARK: - Remove Favorites

    func removeFavorites(at indexSet: IndexSet, userId: UUID?) async {
        guard let userId = userId else { return }

        for index in indexSet {
            let fact = favorites[index]

            do {
                try await favoritesService.removeFavorite(userId: userId, factId: fact.id)
            } catch {
                Logger.log("Failed to remove favorite: \(error)", level: .error)
            }
        }

        // Update local list
        favorites.remove(atOffsets: indexSet)
    }
}
