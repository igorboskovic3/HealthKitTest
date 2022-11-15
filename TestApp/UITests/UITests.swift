//
//  GitHubRunnerHealthAppUITestUITests.swift
//  GitHubRunnerHealthAppUITestUITests
//
//  Created by Paul Shmiedmayer on 11/14/22.
//

import XCTest


final class UITests: XCTestCase {
    func testAddDataToHealthApp() throws {
        do {
            let app = XCUIApplication()
            app.launch()
            
            try exitAppAndOpenHealth(.electrocardiograms)
            try exitAppAndOpenHealth(.steps)
            try exitAppAndOpenHealth(.pushes)
            try exitAppAndOpenHealth(.restingHeartRate)
            try exitAppAndOpenHealth(.activeEnergy)
        } catch {
            let screenshot = XCUIScreen.main.screenshot()
            let fullScreenshotAttachment = XCTAttachment(screenshot: screenshot)
            fullScreenshotAttachment.lifetime = .keepAlways
            
            add(fullScreenshotAttachment)
            throw error
        }
    }
    
    
    private func exitAppAndOpenHealth(_ healthDataType: HealthDataType) throws {
        XCUIDevice.shared.press(.home)
        
        addUIInterruptionMonitor(withDescription: "System Dialog") { alert in
            guard alert.buttons["Allow"].exists else {
                XCTFail("Failed not dismiss alert: \(alert.staticTexts.allElementsBoundByIndex)")
                return false
            }
            
            alert.buttons["Allow"].tap()
            return true
        }
        
        let healthApp = XCUIApplication(bundleIdentifier: "com.apple.Health")
        healthApp.terminate()
        healthApp.activate()
        
        if healthApp.staticTexts["Welcome to Health"].exists {
            healthApp.staticTexts["Continue"].tap()
            healthApp.staticTexts["Continue"].tap()
            healthApp.tables.buttons["Next"].tap()
            healthApp.staticTexts["Continue"].tap()
        }
        
        guard healthApp.tabBars["Tab Bar"].buttons["Browse"].waitForExistence(timeout: 3) else {
            XCTFail("Failed to identify the Add Data Button: \(healthApp.staticTexts.allElementsBoundByIndex)")
            throw XCTestError(.failureWhileWaiting)
        }
        
        healthApp.tabBars["Tab Bar"].buttons["Browse"].tap()
        
        try healthDataType.navigateToElement()
        
        guard healthApp.navigationBars.firstMatch.buttons["Add Data"].waitForExistence(timeout: 3) else {
            XCTFail("Failed to identify the Add Data Button: \(healthApp.buttons.allElementsBoundByIndex)")
            XCTFail("Failed to identify the Add Data Button: \(healthApp.staticTexts.allElementsBoundByIndex)")
            throw XCTestError(.failureWhileWaiting)
        }
        
        healthApp.navigationBars.firstMatch.buttons["Add Data"].tap()
        
        healthDataType.addData()
        
        guard healthApp.navigationBars.firstMatch.buttons["Add"].waitForExistence(timeout: 3) else {
            XCTFail("Failed to identify the Add button: \(healthApp.buttons.allElementsBoundByIndex)")
            XCTFail("Failed to identify the Add button: \(healthApp.staticTexts.allElementsBoundByIndex)")
            throw XCTestError(.failureWhileWaiting)
        }
        
        healthApp.navigationBars.firstMatch.buttons["Add"].tap()
        
        healthApp.terminate()
        
        let testApp = XCUIApplication()
        testApp.activate()
    }
}
