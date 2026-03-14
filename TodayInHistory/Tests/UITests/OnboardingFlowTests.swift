import XCTest

final class OnboardingFlowTests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["--uitesting"]
    }

    func testOnboardingPagesSwipe() throws {
        app.launch()

        // Should start on first page
        XCTAssertTrue(app.staticTexts["Discover History"].exists)

        // Swipe to second page
        app.swipeLeft()
        XCTAssertTrue(app.staticTexts["Explore Cultures"].waitForExistence(timeout: 2))

        // Swipe to third page
        app.swipeLeft()
        XCTAssertTrue(app.staticTexts["Go Pro"].waitForExistence(timeout: 2))
    }

    func testGuestContinueButton() throws {
        app.launch()

        // Guest button should exist
        let guestButton = app.buttons["Continue as Guest"]
        XCTAssertTrue(guestButton.waitForExistence(timeout: 5))
    }

    func testSignInWithAppleButtonExists() throws {
        app.launch()

        // Sign in with Apple button should exist
        let signInButton = app.buttons["Sign in with Apple"]
        XCTAssertTrue(signInButton.waitForExistence(timeout: 5))
    }
}
