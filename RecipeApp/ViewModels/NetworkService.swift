//
//  NetworkService.swift
//  RecipeApp
//
//  Created by Ryan Smetana on 2/16/25.
//

import Foundation

/// Handles all network activity for the app
actor NetworkService {
//    let recipeEndpointString: String = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json" // Malformed

    let recipeEndpointString: String = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json"
    
    static let shared: NetworkService = NetworkService()
    
    private init() { }
    
    func fetchRecipes() async throws -> [Recipe] {
        guard let url = URL(string: self.recipeEndpointString) else { throw AppError.invalidUrlString }
        do {
            let data = try await getData(from: url)            
            let response = try JSONDecoder().decode(Response.self, from: data)
            return response.recipes
        } catch {
            throw AppError.fetchRecipeError(error)
        }
    }
    
    func getData(from url: URL) async throws -> Data {
        let data = try await URLSession.shared.data(from: url)
        return data.0
    }
}
