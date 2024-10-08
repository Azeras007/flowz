//
//  area_developmentUITests.swift
//  area-developmentUITests
//
//  Created by Antoine Laurans on 30/09/2024.
//

import XCTest

class area_developmentUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        // Initialisation de l'application avant chaque test
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        // Méthode exécutée après chaque test, pour nettoyage
        app = nil
    }

    // Test de la navigation vers les logs d'une Area
    func testNavigationToAreaLogs() throws {
        // Vérifier que nous sommes sur l'écran des "Areas"
        XCTAssertTrue(app.staticTexts["Your Areas"].exists, "The Areas screen should be displayed")

        // Assurez-vous qu'au moins une area existe pour naviguer
        let firstArea = app.buttons.element(boundBy: 0)
        XCTAssertTrue(firstArea.exists, "An area should be present")
        
        // Taper sur l'area pour naviguer vers les logs
        firstArea.tap()

        // Vérifier que la vue de logs est affichée après la navigation
        XCTAssertTrue(app.staticTexts["Logs"].exists, "The Logs screen should be displayed")
    }

    // Test de suppression d'une Area
    func testDeleteArea() throws {
        // Assurez-vous qu'une area existe pour suppression
        let firstArea = app.buttons.element(boundBy: 0)
        XCTAssertTrue(firstArea.exists, "An area should be present for deletion")
        
        // Taper sur l'icône de la poubelle (suppression)
        let deleteButton = firstArea.buttons["trash"]
        XCTAssertTrue(deleteButton.exists, "The delete button should be present")
        deleteButton.tap()
        
        // Vérifier qu'un alert de confirmation s'affiche
        let confirmDeleteAlert = app.alerts["Delete Area"]
        XCTAssertTrue(confirmDeleteAlert.exists, "The delete confirmation alert should appear")
        
        // Taper sur le bouton "OK" pour confirmer la suppression
        confirmDeleteAlert.buttons["OK"].tap()
        
        // Vérifier que l'area a été supprimée
        XCTAssertFalse(firstArea.exists, "The area should be deleted")
    }

    // Test d'ajout d'un Trigger
    func testAddTrigger() throws {
        // Vérifier que nous sommes sur l'écran des "Areas"
        XCTAssertTrue(app.staticTexts["Your Areas"].exists, "The Areas screen should be displayed")
        
        // Assurez-vous qu'au moins une area existe pour ajouter un trigger
        let firstArea = app.buttons.element(boundBy: 0)
        XCTAssertTrue(firstArea.exists, "An area should be present")
        
        // Taper sur l'emoji ⚡ pour ajouter un trigger
        let triggerButton = firstArea.buttons["⚡"]
        XCTAssertTrue(triggerButton.exists, "The trigger button should be present")
        triggerButton.tap()

        // Vérifier que le trigger a été activé ou que la vue pour l'ajout de trigger est visible
        // Si vous avez une alerte ou un message de succès, vérifiez-le ici
        XCTAssertTrue(app.staticTexts["Trigger added"].exists, "The Trigger added confirmation should appear")
    }

    // Test de lancement de l'application
    func testLaunch() throws {
        // Vérifier que l'application se lance avec l'écran "Areas"
        XCTAssertTrue(app.staticTexts["Your Areas"].exists, "The Areas screen should be displayed at launch")
    }
}