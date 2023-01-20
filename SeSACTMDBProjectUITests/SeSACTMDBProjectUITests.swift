//
//  SeSACTMDBProjectUITests.swift
//  SeSACTMDBProjectUITests
//
//  Created by CHOI on 2022/11/29.
//

import XCTest

final class SeSACTMDBProjectUITests: XCTestCase {

    override func setUpWithError() throws {
        

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        XCUIApplication().launch()
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        
        app.textFields["emailTextField"].tap()
        app.textFields["emailTextField"].typeText("jack@jack.com")
        
        app.textFields["passwordTextField"].tap()
        app.textFields["passwordTextField"].typeText("jack@jack.com")
        
        app.textFields["checkTextField"].tap()
        app.textFields["checkTextField"].typeText("jack@jack.com")

        app.staticTexts["로그인하기"].tap()
        
        let label = app.staticTexts.element(matching: .any, identifier: "descriptionLabel").label
        XCTAssertEqual(label, "로그인 버튼을 눌렀습니다.")
        
    }
    

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
