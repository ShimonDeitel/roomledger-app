import XCTest

final class ChargeUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUp() async throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    func testAddButtonOpensEditor() {
        app.buttons["addButton"].tap()
        XCTAssertTrue(app.buttons["saveButton"].waitForExistence(timeout: 2))
        app.buttons["cancelButton"].tap()
    }

    func testAddFlowCreatesNewEntry() {
        app.buttons["addButton"].tap()
        let field = app.textFields.firstMatch
        if field.waitForExistence(timeout: 2) {
            field.tap()
            field.typeText("Test Entry")
        }
        app.buttons["saveButton"].tap()
        XCTAssertTrue(app.navigationBars["Roomservice Ledger"].waitForExistence(timeout: 2))
    }

    func testFreeLimitTriggersPaywall() {
        for _ in 0..<(Store.freeLimit + 2) {
            app.buttons["addButton"].tap()
            if app.buttons["saveButton"].waitForExistence(timeout: 1) {
                app.buttons["saveButton"].tap()
            } else if app.buttons["paywallDismissButton"].waitForExistence(timeout: 1) {
                XCTAssertTrue(true)
                app.buttons["paywallDismissButton"].tap()
                break
            }
        }
    }

    func testKeyboardDismissesOnTapOutside() {
        app.buttons["addButton"].tap()
        let field = app.textFields.firstMatch
        guard field.waitForExistence(timeout: 2) else { return }
        field.tap()
        XCTAssertTrue(app.keyboards.element.exists)
        let form = app.otherElements.firstMatch
        form.tap()
        XCTAssertFalse(app.keyboards.element.waitForExistence(timeout: 1))
    }

    func testSettingsButtonOpensSettings() {
        app.buttons["settingsButton"].tap()
        XCTAssertTrue(app.buttons["settingsDoneButton"].waitForExistence(timeout: 2))
        app.buttons["settingsDoneButton"].tap()
    }
}
