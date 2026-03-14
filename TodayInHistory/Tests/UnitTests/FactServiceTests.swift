import XCTest
@testable import TodayInHistory

final class FactServiceTests: XCTestCase {

    // MARK: - Region Tests

    func testAllRegionsCovered() {
        XCTAssertEqual(Region.allCases.count, 5)
        XCTAssertTrue(Region.allCases.contains(.northAmerica))
        XCTAssertTrue(Region.allCases.contains(.europe))
        XCTAssertTrue(Region.allCases.contains(.asia))
        XCTAssertTrue(Region.allCases.contains(.africa))
        XCTAssertTrue(Region.allCases.contains(.southAmerica))
    }

    // MARK: - Topic Tests

    func testAllTopicsCovered() {
        XCTAssertEqual(Topic.allCases.count, 8)
    }

    // MARK: - Fetch Daily Facts

    func testFetchDailyFactsRequiresMockClient() async throws {
        // Given: A date
        // When: Fetching daily facts
        // Then: Should return one approved fact per region

        XCTSkip("Requires mock Supabase client")
    }
}
