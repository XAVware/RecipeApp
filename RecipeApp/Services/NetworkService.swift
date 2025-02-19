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
        } catch _ as DecodingError {
            throw AppError.malformedResponse
        } catch {
            throw AppError.fetchRecipeError(error)
        }
    }
    
    func getData(from url: URL) async throws -> Data {
        let data = try await URLSession.shared.data(from: url)
        return data.0
    }
    
    func getData(from urlStr: String) async throws -> Data {
        let url = try getUrl(from: urlStr)
        return try await getData(from: url)
    }
    
    private func getUrl(from urlString: String) throws -> URL {
        guard let url = URL(string: urlString) else { throw AppError.invalidUrlString }
        return url
    }
}
