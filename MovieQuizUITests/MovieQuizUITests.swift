//
//  MovieQuizUITests.swift
//  MovieQuizUITests
//
//  Created by Anton Filipchuk on 13.08.2023.
//

import XCTest

final class MovieQuizUITests: XCTestCase {
    
    var app: XCUIApplication!
    
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
    
    func testExample() throws {
        let app = XCUIApplication()
        app.launch()
    }
    
    func testYesButton() {
        sleep(3)
        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        app.buttons["Yes"].tap()
        sleep(3)
        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        let indexLabel = app.staticTexts["Index"]
        XCTAssertFalse(firstPosterData == secondPosterData)
        XCTAssertEqual(indexLabel.label, "2/10")
    }
    
    func testNoButton() {
        sleep(3)
        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        app.buttons["No"].tap()
        sleep(3)
        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        let indexLabel = app.staticTexts["Index"]
        XCTAssertFalse(firstPosterData == secondPosterData)
        XCTAssertEqual(indexLabel.label, "2/10")
    }
    
    func testShowFinalScreen() {
        sleep(3)
        for _ in 1...10 {
            app.buttons["No"].tap()
            sleep(3)
        }        
        let alert = app.alerts["Этот раунд окончен!"]
        XCTAssertTrue(alert.exists)
        XCTAssertEqual(alert.label, "Этот раунд окончен!")
        XCTAssertEqual(alert.buttons.firstMatch.label, "Сыграть еще раз")
    }
    
    func testHideFinalScreen() {
        sleep(3)
        for _ in 1...10 {
            app.buttons["No"].tap()
            sleep(3)
        }
        let alert = app.alerts["Этот раунд окончен!"]
        alert.buttons.firstMatch.tap()
        sleep(3)
        let indexLabel = app.staticTexts["Index"]
        XCTAssertFalse(alert.exists)
        XCTAssertEqual(indexLabel.label, "1/10")
    }
}
