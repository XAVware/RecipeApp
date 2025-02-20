//
//  NetworkServiceTest.swift
//  RecipeApp
//
//  Created by Ryan Smetana on 2/19/25.
//

import Testing
@testable import RecipeApp
import Foundation
import UIKit

@Suite("Network service tests") final class NetworkServiceTestSuite {
    
    private var sut: NetworkService!
    
    let validJsonUrlString = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json"
    let malformedJsonUrlString = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json" 
    
    init() async {
        sut = NetworkService.shared
    }
    
    @Test("JSON decodes properly") func testJSONDecoding() async throws {
        let validJSON = """
        {
            "recipes": [
                {
                    "cuisine": "British",
                    "name": "Bakewell Tart",
                    "photo_url_large": "https://some.url/large.jpg",
                    "photo_url_small": "https://some.url/small.jpg",
                    "uuid": "eed6005f-f8c8-451f-98d0-4088e2b40eb6",
                    "source_url": "https://some.url/index.html",
                    "youtube_url": "https://www.youtube.com/watch?v=some.id"
                }
            ]
        }
        """
        
        let response = try await sut.decodeResponseData(validJSON.data(using: .utf8)!)
        #expect(response != nil)
        #expect(response.recipes[0].cuisine == "British")
        // Test remaining pairs...
    }
    
    @Test("Valid json fetched successfully") func fetchValidJson() async throws {
        let recipes = try await sut.fetchRecipes(from: validJsonUrlString)
        #expect(!recipes.isEmpty)
    }
}
