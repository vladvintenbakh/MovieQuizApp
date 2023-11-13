//
//  MovieQuizUITests.swift
//  MovieQuizUITests
//
//  Created by Vladislav Vintenbakh on 13/11/23.
//

import XCTest

var app: XCUIApplication!

final class MovieQuizUITests: XCTestCase {

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        app = XCUIApplication()
        app.launch()
        
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        app.terminate()
        app = nil
    }
    
    func testYesButton() {
        sleep(3)
        
        let firstPoster = app.images["Poster"] // locate the initial poster
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        
        app.buttons["Yes"].tap() // locate the "Yes" button and tap it
        
        sleep(3)
        
        let secondPoster = app.images["Poster"] // locate the poster again
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        
        XCTAssertNotEqual(firstPosterData, secondPosterData) // check that the posters are different
        
        let indexLabel = app.staticTexts["Index"]
        XCTAssertEqual(indexLabel.label, "2/10") // check that the question index label changes correctly
    }
    
    func testNoButton() {
        sleep(3)
        
        let firstPoster = app.images["Poster"] // locate the initial poster
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        
        app.buttons["No"].tap() // locate the "No" button and tap it
        
        sleep(3)
        
        let secondPoster = app.images["Poster"] // locate the poster again
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        
        XCTAssertNotEqual(firstPosterData, secondPosterData) // check that the posters are different
        
        let indexLabel = app.staticTexts["Index"]
        XCTAssertEqual(indexLabel.label, "2/10") // check that the question index label changes correctly
    }
    
    func testAlertShown() {
        let numQuestions = 10
        
        let yesButton = app.buttons["Yes"]
        
        for _ in 0..<numQuestions {
            sleep(3)
            yesButton.tap()
        }
        
        sleep(1)
        
        let alert = app.alerts.element
        XCTAssert(alert.exists)
        
        let title = alert.staticTexts.element(boundBy: 0).label
        let buttonText = alert.buttons.firstMatch.label
        
        XCTAssertEqual(title, "Quiz round completed")
        XCTAssertEqual(buttonText, "Play again")
    }
    
    func testDismissAlert() {
        let numQuestions = 10
        
        let yesButton = app.buttons["Yes"]
        
        for _ in 0..<numQuestions {
            sleep(3)
            yesButton.tap()
        }
        
        sleep(1)
        
        let alert = app.alerts.element
        alert.buttons.firstMatch.tap()
        
        sleep(3)
        
        let indexLabel = app.staticTexts["Index"]
        
        XCTAssertFalse(alert.exists)
        XCTAssertEqual(indexLabel.label, "1/10")
    }
}
