//
//  ImageFeedUITests.swift
//  ImageFeedUITests
//
//  Created by Давид Бекоев on 04.07.2024.
//

import XCTest

final class Image_FeedUITests: XCTestCase {
    private let app = XCUIApplication()// переменная приложения
    //        enum UserData {
    //            static let username = ""
    //            static let password = ""
    //            static let fullName = ""
    //            static let userName = ""
    //        }
    override func setUpWithError() throws {
        continueAfterFailure = false // настройка выполнения тестов, которая прекратит выполнения тестов, если в тесте что-то пошло не так
        app.launchEnvironment = ["isUITesting": "YES"]
        app.launch() // запускаем приложение перед каждым тестом
    }
    
    func testAuth() throws {
        app.buttons["Authenticate"].tap()
         
         let webView = app.webViews["UnsplashWebView"]
         
         XCTAssertTrue(webView.waitForExistence(timeout: 5))

         let loginTextField = webView.descendants(matching: .textField).element
         XCTAssertTrue(loginTextField.waitForExistence(timeout: 10))
         
         loginTextField.tap()
         loginTextField.typeText("bekoevdawid@yandex.ru")
         webView.swipeUp()
         
         
         let passwordTextField = webView.descendants(matching: .secureTextField).element
         XCTAssertTrue(passwordTextField.waitForExistence(timeout: 10))
         
         passwordTextField.tap()
         sleep(2)
         passwordTextField.typeText("D2a0v0i2d11")
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
        // тестируем сценарий ленты
    }
    
    func testProfile() throws {
        // тестируем сценарий профиля
        func testProfile() throws {
            sleep(3)
            app.tabBars.buttons.element(boundBy: 1).tap()
           
            XCTAssertTrue(app.staticTexts["David Bekoev"].exists)
            XCTAssertTrue(app.staticTexts["@davidbekoev"].exists)
            
            app.buttons["logout button"].tap()
            
            app.alerts["Bye bye!"].scrollViews.otherElements.buttons["Yes"].tap()
        }
    }
}

