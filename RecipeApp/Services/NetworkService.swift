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
    static let shared: NetworkService = NetworkService()
    
    private init() { }
    
    func fetchRecipes(from urlString: String = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json") async throws -> [Recipe] {
        guard let url = URL(string: urlString) else { throw AppError.invalidUrlString }
        do {
            let data = try await getData(from: url)            
            let response = try decodeResponseData(data)
            return response.recipes
        } catch _ as DecodingError {
            throw AppError.malformedResponse
        } catch {
            throw AppError.fetchRecipeError(error)
        }
    }
    
    /// Decode data into a `Response` data model
    /// 
    /// Load recipes from the web to display on the home page. Sets the `recipes` array to the retrieved data.
    /// 
    /// - Parameters: 
    ///    - data: The data to attempt to decode into a `Response`
    /// - Returns: Valid `Response` object
    /// - SeeAlso: `Response`
    func decodeResponseData(_ data: Data) throws -> Response {
        return try JSONDecoder().decode(Response.self, from: data)
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
