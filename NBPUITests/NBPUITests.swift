//
//  NBPUITests.swift
//  NBPUITests
//
//  Created by Maksymilian Stan on 15/03/2023.
//

import XCTest

final class NBPUITests: XCTestCase {
    let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }
    
    func testInputViewButtonIsHidden() {
        // then
        XCTAssertFalse(!app.buttons.element(boundBy: 1).isHittable)
    }
    
    func testOutputViewButtonIsHidden() {
        // then
        XCTAssertFalse(!app.buttons.element(boundBy: 2).isHittable)
    }
    
    func testFirstLabelShouldDisplayTHB() {
        // when
        app.buttons.element(boundBy: 1).tap()
        app.scrollViews.buttons.element(boundBy: 0).tap()
        
        // then
        XCTAssertEqual(app.staticTexts.element(boundBy: 0).label , "THB")
    }
    
    func testSecondLabelShouldDisplayTHB() {
        // when
        app.buttons.element(boundBy: 2).tap()
        app.scrollViews.buttons.element(boundBy: 1).tap()
        
        // then
        XCTAssertEqual(app.staticTexts.element(boundBy: 0).label , "USD")
    }
    
    func testReverseButtonLabelShouldBeUSD() {
        // when
        app.buttons.element(boundBy: 1).tap()
        app.scrollViews.buttons.element(boundBy: 0).tap()
        
        app.buttons.element(boundBy: 2).tap()
        app.scrollViews.buttons.element(boundBy: 1).tap()
        
        app.buttons["sort"].tap()
        
        // then
        XCTAssertEqual(app.staticTexts.element(boundBy: 0).label, "USD")
    }
    
    func testReverseButtonTextFieldShouldBeSecondTextFieldValue() {
        // when
        app.buttons.element(boundBy: 1).tap()
        app.scrollViews.buttons.element(boundBy: 0).tap()
        
        app.buttons.element(boundBy: 2).tap()
        app.scrollViews.buttons.element(boundBy: 1).tap()
        
        app.textFields.element(boundBy: 0).tap()
        
        app.keys["2"].tap()
        app.keys["4"].tap()
        
        let secondTextFieldValue = app.textFields.element(boundBy: 1).value as? String
        
        app.buttons["sort"].tap()
        
        // then
        XCTAssertEqual(app.textFields.element(boundBy: 0).value as? String, secondTextFieldValue)
    }
    
    func testThereIsOutput() {
        // when
        app.buttons.element(boundBy: 1).tap()
        app.scrollViews.buttons.element(boundBy: 0).tap()
        
        app.buttons.element(boundBy: 2).tap()
        app.scrollViews.buttons.element(boundBy: 1).tap()
        
        app.textFields.element(boundBy: 0).tap()
        
        app.keys["2"].tap()
        app.keys["4"].tap()
        
        // then
        XCTAssertNotEqual(app.textFields.element(boundBy: 1).value as? String, "")
    }
    
    func testKeyboardShouldHideOnTap() {
        // when
        app.buttons.element(boundBy: 1).tap()
        app.scrollViews.buttons.element(boundBy: 0).tap()
        
        app.buttons.element(boundBy: 2).tap()
        app.scrollViews.buttons.element(boundBy: 1).tap()
        
        app.textFields.element(boundBy: 0).tap()
        
        app.tap()
        
        // then
        XCTAssertEqual(app.keyboards.count, 0)
    }
    
    func testTouchingWithoutCurrenciesShouldPresentError() {
        // when
        app.buttons["sort"].tap()
        
        // then
        XCTAssert(app.alerts["Error"].exists)
    }
    
    func testTouchWithoutInputCurrencyShouldPresentError() {
        // when
        app.buttons.element(boundBy: 1).tap()
        app.scrollViews.buttons.element(boundBy: 0).tap()
        
        app.buttons["sort"].tap()
        
        // then
        XCTAssert(app.alerts["Error"].exists)
    }
    
    func testTouchWithoutOutputCurrencyShouldPresentError() {
        // when
        app.buttons.element(boundBy: 2).tap()
        app.scrollViews.buttons.element(boundBy: 0).tap()
        
        app.buttons["sort"].tap()
        
        // then
        XCTAssert(app.alerts["Error"].exists)
    }
}
