import Foundation

@MainActor
final class ProfileViewModel: ObservableObject {

    @Published var isLoading = false
    @Published var error: Error?
    @Published var showAreaSelection = false

    // MARK: - Update Area of Interest

    func updateAreaOfInterest(_ region: Region, authService: AuthService) async {
        isLoading = true
        defer { isLoading = false }

        do {
            try await authService.setAreaOfInterest(region)
        } catch {
            self.error = error
            Logger.log("Failed to update area of interest: \(error)", level: .error)
        }
    }
}
