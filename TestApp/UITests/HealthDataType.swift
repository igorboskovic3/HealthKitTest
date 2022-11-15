//
//  GitHubRunnerHealthAppUITestUITestsLaunchTests.swift
//  GitHubRunnerHealthAppUITestUITests
//
//  Created by Paul Shmiedmayer on 11/14/22.
//

import XCTest


enum HealthDataType: String {
    case activeEnergy = "Active Energy"
    case restingHeartRate = "Resting Heart Rate"
    case electrocardiograms = "Electrocardiograms (ECG)"
    case steps = "Steps"
    case pushes = "Pushes"
    
    
    var hkTypeNames: String {
        switch self {
        case .activeEnergy:
            return "HKQuantityTypeIdentifierActiveEnergyBurned"
        case .restingHeartRate:
            return "HKQuantityTypeIdentifierRestingHeartRate"
        case .electrocardiograms:
            return "HKDataTypeIdentifierElectrocardiogram"
        case .steps:
            return "HKQuantityTypeIdentifierStepCount"
        case .pushes:
            return "HKQuantityTypeIdentifierPushCount"
        }
    }
    
    var category: String {
        switch self {
        case .activeEnergy, .steps, .pushes:
            return "Activity"
        case .restingHeartRate, .electrocardiograms:
            return "Heart"
        }
    }
    
    
    func navigateToElement() throws {
        let healthApp = XCUIApplication(bundleIdentifier: "com.apple.Health")
        
        if healthApp.navigationBars["Browse"].buttons["Cancel"].exists {
            healthApp.navigationBars["Browse"].buttons["Cancel"].tap()
        }
        try findCategoryAndElement(in: healthApp)
    }
    
    private func findCategoryAndElement(in healthApp: XCUIApplication) throws {
        // Find category:
        let categoryStaticTextPredicate = NSPredicate(format: "label CONTAINS[cd] %@", category)
        let categoryStaticText = healthApp.staticTexts.element(matching: categoryStaticTextPredicate).firstMatch
        
        if categoryStaticText.waitForExistence(timeout: 1) {
            categoryStaticText.tap()
        } else {
            XCTFail("Failed to find category: \(healthApp.staticTexts.allElementsBoundByIndex)")
            throw XCTestError(.failureWhileWaiting)
        }
        
        // Find element:
        let elementStaticTextPredicate = NSPredicate(format: "label CONTAINS[cd] %@", rawValue)
        var elementStaticText = healthApp.staticTexts.element(matching: elementStaticTextPredicate).firstMatch
        
        guard elementStaticText.waitForExistence(timeout: 3) else {
            healthApp.firstMatch.swipeUp(velocity: .slow)
            elementStaticText = healthApp.buttons.element(matching: elementStaticTextPredicate).firstMatch
            if elementStaticText.waitForExistence(timeout: 3) {
                elementStaticText.tap()
                return
            }
            XCTFail("Failed to find element in category: \(healthApp.staticTexts.allElementsBoundByIndex)")
            throw XCTestError(.failureWhileWaiting)
        }
        
        elementStaticText.tap()
    }
    
    func addData() {
        let healthApp = XCUIApplication(bundleIdentifier: "com.apple.Health")
        
        switch self {
        case .activeEnergy:
            healthApp.tables.textFields["cal"].tap()
            healthApp.tables.textFields["cal"].typeText("42")
        case .restingHeartRate:
            healthApp.tables.textFields["BPM"].tap()
            healthApp.tables.textFields["BPM"].typeText("80")
        case .electrocardiograms:
            healthApp.tables.staticTexts["High Heart Rate"].tap()
        case .steps:
            healthApp.tables.textFields["Steps"].tap()
            healthApp.tables.textFields["Steps"].typeText("42")
        case .pushes:
            healthApp.tables.textFields["Pushes"].tap()
            healthApp.tables.textFields["Pushes"].typeText("42")
        }
    }
}
