import Foundation
import SwiftUI

@MainActor
final class HomeViewModel: ObservableObject {

    @Published var mainFact: Fact?
    @Published var worldContext: [WorldContext] = []
    @Published var isLoading = false
    @Published var error: Error?
    @Published var expandedRegion: Region?

    private let factService = FactService()

    // MARK: - Load Content

    /// Loads the main fact and world context for the user's area of interest.
    /// Pass authService in at call time to avoid init-time EnvironmentObject unavailability.
    func loadContent(authService: AuthService) async {
        guard let region = authService.currentUser?.areaOfInterest else {
            // User hasn't selected an area of interest yet - onboarding handles this
            return
        }

        isLoading = true
        error = nil
        defer { isLoading = false }

        do {
            // Fetch today's main fact for the user's region
            let fact = try await factService.fetchTodayFact(for: region)
            mainFact = fact

            // Fetch world context if we have a fact
            if let fact = fact {
                worldContext = try await factService.fetchWorldContext(for: fact.id)
            } else {
                worldContext = []
            }
        } catch {
            self.error = error
            Logger.log("Failed to load home content: \(error)", level: .error)
        }
    }

    // MARK: - Refresh

    func refresh(authService: AuthService) async {
        await loadContent(authService: authService)
    }

    // MARK: - Toggle Region Expansion

    func toggleRegion(_ region: Region) {
        withAnimation(.easeInOut(duration: 0.25)) {
            expandedRegion = expandedRegion == region ? nil : region
        }
    }

    // MARK: - Helpers

    /// World context rows sorted by region display name
    var contextRows: [WorldContext] {
        worldContext
    }
}
