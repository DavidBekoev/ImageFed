//
//  ImageFeedUITests.swift
//  ImageFeedUITests
//
//  Created by Давид Бекоев on 04.07.2024.
//

import XCTest

final class Image_FeedUITests: XCTestCase {
    private let app = XCUIApplication()
    enum UserData {
        static let username = ""
        static let password = ""
        static let fullName = ""
        static let userName = ""
    }
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launchEnvironment = ["isUITesting": "YES"]
        app.launch()
    }
    
    func testAuth() throws {
        app.buttons["Authenticate"].tap()
        
        let webView = app.webViews["UnsplashWebView"]
        
        XCTAssertTrue(webView.waitForExistence(timeout: 5))
        
        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 10))
        
        loginTextField.tap()
        loginTextField.typeText(UserData.username)
        webView.swipeUp()
        
        
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 10))
        
        passwordTextField.tap()
        sleep(2)
        passwordTextField.typeText(UserData.password)
        webView.swipeUp()
        
        webView.buttons["Login"].tap()
        
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
        
    }
    
    func testFeed() throws {
        let tablesQuery = app.tables
        
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        XCTAssertTrue(cell.waitForExistence(timeout: 10))
        cell.swipeUp()
        
        let cellToLike = tablesQuery.children(matching: .cell).element(boundBy: 1)
        if cellToLike.buttons["like_button_off"].waitForExistence(timeout: 5) {
            cellToLike.buttons["like_button_off"].tap()
            XCTAssertTrue(cellToLike.buttons["like_button_on"].waitForExistence(timeout: 5))
            cellToLike.buttons["like_button_on"].tap()
            XCTAssertTrue(cellToLike.buttons["like_button_off"].waitForExistence(timeout: 5))
        } else {
            XCTAssertTrue(cellToLike.buttons["like_button_on"].waitForExistence(timeout: 5))
            cellToLike.buttons["like_button_on"].tap()
            XCTAssertTrue(cellToLike.buttons["like_button_off"].waitForExistence(timeout: 5))
            cellToLike.buttons["like_button_off"].tap()
            XCTAssertTrue(cellToLike.buttons["like_button_on"].waitForExistence(timeout: 5))
        }
        
        cellToLike.tap()
        let fullImage = app.scrollViews.images["full_image"]
        XCTAssertTrue(fullImage.waitForExistence(timeout: 30))
        sleep(1)
        
        fullImage.pinch(withScale: 3, velocity: 1)
        fullImage.pinch(withScale: 0.5, velocity: -1)
        
        let navBackButtonWhiteButton = app.buttons["nav_back_button"]
        navBackButtonWhiteButton.tap()
        
    }
    
    func testProfile() throws {
        
        let profileTab = app.tabBars.buttons.element(boundBy: 1)
        XCTAssertTrue(profileTab.waitForExistence(timeout: 10))
        profileTab.tap()
        
        XCTAssertTrue(app.staticTexts[UserData.fullName].waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts[UserData.userName].waitForExistence(timeout: 5))
        
        app.buttons["logoutButton"].tap()
        
        let yesButton = app.alerts.buttons["yesAlertButton"]
        XCTAssertTrue(yesButton.waitForExistence(timeout: 5))
        yesButton.tap()
        
        let loginButton = app.buttons["Authenticate"]
        XCTAssertTrue(loginButton.waitForExistence(timeout: 10))
    }
    
}

