import Foundation
import AuthenticationServices
import Supabase

@MainActor
final class AuthService: ObservableObject {

    @Published var currentUser: User?
    @Published var isAuthenticated = false
    @Published var isGuest = false
    @Published var isLoading = false

    private let supabase = SupabaseClient.shared

    // MARK: - Session Check

    func checkSession() async {
        isLoading = true
        defer { isLoading = false }

        do {
            let session = try await supabase.auth.session
            isAuthenticated = true
            isGuest = session.user.isAnonymous
            await loadCurrentUser()
        } catch {
            isAuthenticated = false
            isGuest = false
            currentUser = nil
        }
    }

    // MARK: - Sign In with Apple

    func signInWithApple(credential: ASAuthorizationAppleIDCredential) async throws {
        guard let identityToken = credential.identityToken,
              let idToken = String(data: identityToken, encoding: .utf8) else {
            throw APIError.authenticationRequired
        }

        try await supabase.auth.signInWithIdToken(
            credentials: .init(provider: .apple, idToken: idToken)
        )

        isAuthenticated = true
        isGuest = false

        // Create or update user profile
        await createOrUpdateUserProfile(
            displayName: credential.fullName?.formatted()
        )

        await loadCurrentUser()
    }

    // MARK: - Guest Auth

    func continueAsGuest() async throws {
        try await supabase.auth.signInAnonymously()

        isAuthenticated = true
        isGuest = true

        await createOrUpdateUserProfile(displayName: nil)
        await loadCurrentUser()
    }

    // MARK: - Account Linking (Guest to Apple)

    func linkAppleAccount(credential: ASAuthorizationAppleIDCredential) async throws {
        guard let identityToken = credential.identityToken,
              let idToken = String(data: identityToken, encoding: .utf8) else {
            throw APIError.authenticationRequired
        }

        // Preserve existing data before linking
        let existingFavorites = try await fetchUserFavorites()

        // Link the account
        try await supabase.auth.linkIdentity(
            credentials: .init(provider: .apple, idToken: idToken)
        )

        // Update profile with Apple display name
        await createOrUpdateUserProfile(
            displayName: credential.fullName?.formatted()
        )

        // Restore favorites to linked account
        try await restoreFavorites(existingFavorites)

        isGuest = false
        await loadCurrentUser()
    }

    // MARK: - Area of Interest

    var needsAreaSelection: Bool {
        currentUser?.areaOfInterest == nil
    }

    func setAreaOfInterest(_ region: Region) async throws {
        guard let userId = currentUser?.id else {
            throw APIError.authenticationRequired
        }

        let updateData: [String: AnyJSON] = [
            "area_of_interest": .string(region.rawValue)
        ]

        try await supabase
            .from(SupabaseClient.Table.users)
            .update(updateData)
            .eq("id", value: userId.uuidString)
            .execute()

        // Update local currentUser state
        currentUser?.areaOfInterest = region
    }

    // MARK: - Sign Out

    func signOut() async throws {
        try await supabase.auth.signOut()

        currentUser = nil
        isAuthenticated = false
        isGuest = false
    }

    // MARK: - Private Helpers

    private func loadCurrentUser() async {
        do {
            let userId = try await supabase.auth.session.user.id

            let user: User = try await supabase
                .from(SupabaseClient.Table.users)
                .select()
                .eq("id", value: userId)
                .single()
                .execute()
                .value

            currentUser = user
        } catch {
            Logger.log("Failed to load user: \(error)", level: .error)
        }
    }

    private func createOrUpdateUserProfile(displayName: String?) async {
        do {
            let userId = try await supabase.auth.session.user.id

            let userData: [String: AnyJSON] = [
                "id": .string(userId.uuidString),
                "display_name": displayName.map { .string($0) } ?? .null
            ]

            try await supabase
                .from(SupabaseClient.Table.users)
                .upsert(userData)
                .execute()
        } catch {
            Logger.log("Failed to create/update user: \(error)", level: .error)
        }
    }

    private func fetchUserFavorites() async throws -> [UUID] {
        let userId = try await supabase.auth.session.user.id

        struct FavoriteRow: Codable {
            let factId: UUID

            enum CodingKeys: String, CodingKey {
                case factId = "fact_id"
            }
        }

        let favorites: [FavoriteRow] = try await supabase
            .from(SupabaseClient.Table.favorites)
            .select("fact_id")
            .eq("user_id", value: userId)
            .execute()
            .value

        return favorites.map { $0.factId }
    }

    private func restoreFavorites(_ factIds: [UUID]) async throws {
        guard !factIds.isEmpty else { return }

        let userId = try await supabase.auth.session.user.id

        let favorites = factIds.map { factId -> [String: AnyJSON] in
            [
                "user_id": .string(userId.uuidString),
                "fact_id": .string(factId.uuidString)
            ]
        }

        try await supabase
            .from(SupabaseClient.Table.favorites)
            .upsert(favorites)
            .execute()
    }
}

// MARK: - Apple Sign In Handler

extension AuthService {
    func handleAppleSignIn(_ result: Result<ASAuthorization, Error>) async throws {
        switch result {
        case .success(let authorization):
            guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else {
                throw APIError.authenticationRequired
            }

            if isGuest {
                try await linkAppleAccount(credential: credential)
            } else {
                try await signInWithApple(credential: credential)
            }

        case .failure(let error):
            throw error
        }
    }
}
