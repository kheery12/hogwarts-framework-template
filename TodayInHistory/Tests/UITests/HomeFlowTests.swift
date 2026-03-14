import XCTest

final class HomeFlowTests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["--uitesting", "--skip-onboarding"]
    }

    func testHomeScreenShowsTitle() throws {
        app.launch()

        let navBar = app.navigationBars["Today in History"]
        XCTAssertTrue(navBar.waitForExistence(timeout: 5))
    }

    func testTabBarNavigation() throws {
        app.launch()

        // Home tab
        XCTAssertTrue(app.tabBars.buttons["Today"].exists)

        // Favorites tab
        let favoritesTab = app.tabBars.buttons["Favorites"]
        XCTAssertTrue(favoritesTab.exists)
        favoritesTab.tap()
        XCTAssertTrue(app.navigationBars["Favorites"].waitForExistence(timeout: 2))

        // Profile tab
        let profileTab = app.tabBars.buttons["Profile"]
        XCTAssertTrue(profileTab.exists)
        profileTab.tap()
        XCTAssertTrue(app.navigationBars["Profile"].waitForExistence(timeout: 2))
    }

    func testFactCardTapOpensDetail() throws {
        app.launch()

        // Wait for facts to load
        let firstCard = app.buttons.matching(identifier: "FactCard").firstMatch
        guard firstCard.waitForExistence(timeout: 10) else {
            XCTSkip("No facts loaded - requires backend data")
            return
        }

        firstCard.tap()

        // Should show detail view with Wikipedia link
        let readMoreButton = app.buttons["Read Full Article on Wikipedia"]
        XCTAssertTrue(readMoreButton.waitForExistence(timeout: 5))
    }
}
