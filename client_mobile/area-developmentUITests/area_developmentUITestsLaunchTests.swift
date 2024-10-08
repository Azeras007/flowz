//
//  area_developmentUITestsLaunchTests.swift
//  area-developmentUITests
//
//  Created by Antoine Laurans on 30/09/2024.
//

import XCTest

class area_developmentUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        // Initialiser avant chaque test
        continueAfterFailure = false
    }

    // Test de lancement de l'application
    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        // Prendre une capture d'écran du lancement
        let screenshot = app.screenshot()
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)

        // Vérifier que l'écran "Your Areas" est bien affiché au lancement
        XCTAssertTrue(app.staticTexts["Your Areas"].exists, "The Areas screen should be displayed at launch")
    }

    // Test de lancement avec connexion utilisateur
    func testLaunchWithLogin() throws {
        let app = XCUIApplication()
        app.launch()

        // Simuler un processus de connexion ici si nécessaire
        let loginButton = app.buttons["Login"]
        if loginButton.exists {
            loginButton.tap()
            
            // Simuler la saisie des informations de connexion
            let emailField = app.textFields["Email"]
            XCTAssertTrue(emailField.exists, "The email field should be present")
            emailField.tap()
            emailField.typeText("test@example.com")

            let passwordField = app.secureTextFields["Password"]
            XCTAssertTrue(passwordField.exists, "The password field should be present")
            passwordField.tap()
            passwordField.typeText("password123")

            let submitButton = app.buttons["Submit"]
            XCTAssertTrue(submitButton.exists, "The submit button should be present")
            submitButton.tap()
        }

        // Vérifier que l'écran principal s'affiche après la connexion
        XCTAssertTrue(app.staticTexts["Your Areas"].exists, "The Areas screen should be displayed after login")

        // Capture d'écran de l'écran après la connexion
        let screenshot = app.screenshot()
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.name = "Login Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}