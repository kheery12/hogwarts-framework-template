import XCTest
@testable import TodayInHistory

final class AuthServiceTests: XCTestCase {

    func testGuestUserIdentification() async throws {
        // Guest users should be marked as isGuest = true
        XCTSkip("Requires mock Supabase auth")
    }

    func testGuestToAppleLinkingPreservesFavorites() async throws {
        // Given: Guest user with favorites
        // When: Linking Apple account
        // Then: Favorites should persist after linking

        XCTSkip("Requires mock implementation")
    }

    func testUserHasAreaOfInterestAfterOnboarding() {
        // Given: A user who completed onboarding
        let user = User(
            id: UUID(),
            displayName: "Test",
            areaOfInterest: .northAmerica,
            createdAt: Date()
        )

        // Then: areaOfInterest should be set
        XCTAssertNotNil(user.areaOfInterest)
        XCTAssertEqual(user.areaOfInterest, .northAmerica)
    }

    func testNewUserHasNoAreaOfInterest() {
        // Given: A user who has not completed onboarding
        let user = User(
            id: UUID(),
            displayName: nil,
            areaOfInterest: nil,
            createdAt: Date()
        )

        // Then: areaOfInterest should be nil
        XCTAssertNil(user.areaOfInterest)
    }
}
