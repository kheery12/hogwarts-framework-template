import Foundation

@MainActor
final class FactDetailViewModel: ObservableObject {

    @Published var isFavorited = false
    @Published var isLoading = false

    let fact: Fact
    private let favoritesService = FavoritesService()

    init(fact: Fact) {
        self.fact = fact
    }

    // MARK: - Check Favorite Status

    func checkFavoriteStatus(userId: UUID?) async {
        guard let userId = userId else {
            isFavorited = false
            return
        }

        isFavorited = await favoritesService.isFavorited(userId: userId, factId: fact.id)
    }

    // MARK: - Toggle Favorite

    func toggleFavorite(userId: UUID?) async {
        guard let userId = userId else { return }

        isLoading = true
        defer { isLoading = false }

        do {
            let isNowFavorited = try await favoritesService.toggleFavorite(
                userId: userId,
                fact: fact
            )
            isFavorited = isNowFavorited
        } catch {
            Logger.log("Failed to toggle favorite: \(error)", level: .error)
        }
    }
}
