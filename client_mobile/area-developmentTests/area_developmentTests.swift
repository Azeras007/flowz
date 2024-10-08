//
//  area_developmentTests.swift
//  area-developmentTests
//
//  Created by Antoine Laurans on 30/09/2024.
//

import XCTest
@testable import area_development

class area_developmentTests: XCTestCase {

    // Exemple de setup avant chaque test
    override func setUpWithError() throws {
        // Mettez en place ce qui est nécessaire avant chaque test
    }

    // Exemple de teardown après chaque test
    override func tearDownWithError() throws {
        // Nettoyage après chaque test si nécessaire
    }

    // Test de la récupération des Areas
    func testFetchAreas() throws {
        // Simuler une réponse d'API JSON
        let jsonResponse = """
        {
            "data": [
                {
                    "id": 1,
                    "name": "Test Area 1",
                    "listener_id": 2,
                    "action_id": 3,
                    "status": true,
                    "created_at": "2024-10-01T12:00:00Z"
                }
            ],
            "meta": {
                "current_page": 1,
                "from": 1,
                "last_page": 1,
                "per_page": 20,
                "to": 1,
                "total": 1
            },
            "links": {
                "first": "https://example.com/areas?page=1",
                "last": "https://example.com/areas?page=1",
                "next": null,
                "prev": null
            }
        }
        """.data(using: .utf8)!

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        do {
            let decodedResponse = try decoder.decode(AreaResponse.self, from: jsonResponse)
            
            // Vérification des valeurs décodées
            XCTAssertEqual(decodedResponse.data.count, 1)
            XCTAssertEqual(decodedResponse.data.first?.name, "Test Area 1")
            XCTAssertEqual(decodedResponse.data.first?.listener_id, 2)
            XCTAssertEqual(decodedResponse.meta.total, 1)
        } catch {
            XCTFail("Decoding failed: \(error)")
        }
    }

    // Test de la suppression d'une Area
    func testDeleteArea() throws {
        // Simuler l'appel de suppression et vérifier la réponse
        let url = URL(string: "https://area-development.tech/api/areas/1/delete")!
        let expectation = self.expectation(description: "Area deletion")
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            XCTAssertNil(error, "Error should be nil")
            
            // Vérification du code de statut HTTP
            if let httpResponse = response as? HTTPURLResponse {
                XCTAssertEqual(httpResponse.statusCode, 200)
            } else {
                XCTFail("Invalid response")
            }
            
            expectation.fulfill()
        }
        
        task.resume()
        wait(for: [expectation], timeout: 5.0)
    }
    
    // Test du modèle Area
    func testAreaModelDecoding() throws {
        // Simuler une réponse d'API JSON pour une seule Area
        let jsonResponse = """
        {
            "id": 1,
            "name": "Test Area",
            "listener_id": 2,
            "action_id": 3,
            "status": true,
            "created_at": "2024-10-01T12:00:00Z"
        }
        """.data(using: .utf8)!

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        do {
            let decodedArea = try decoder.decode(Area.self, from: jsonResponse)
            
            // Vérification des valeurs décodées
            XCTAssertEqual(decodedArea.id, 1)
            XCTAssertEqual(decodedArea.name, "Test Area")
            XCTAssertEqual(decodedArea.listener_id, 2)
            XCTAssertEqual(decodedArea.action_id, 3)
            XCTAssertTrue(decodedArea.status)
            XCTAssertNotNil(decodedArea.created_at)
        } catch {
            XCTFail("Decoding failed: \(error)")
        }
    }
}