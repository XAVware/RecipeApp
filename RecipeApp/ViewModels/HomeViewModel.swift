//
//  HomeViewModel.swift
//  RecipeApp
//
//  Created by Ryan Smetana on 2/16/25.
//

import SwiftUI

/// Handles all network activity for the app
actor NetworkService {
    static let shared: NetworkService = NetworkService()
    
    private init() { }
    
    
    // Fetch recipes
    
    /// Fetch data from a URL
    func getData(from url: URL) async throws -> Data {
        let data = try await URLSession.shared.data(from: url)
        return data.0
    }
}

@Observable
class HomeViewModel {
    
    var text = """
    {
        "recipes": [
            {
                "cuisine": "Malaysian",
                "name": "Apam Balik",
                "photo_url_large": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/7276e9f9-02a2-47a0-8d70-d91bdb149e9e/large.jpg",
                "photo_url_small": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg",
                "source_url": "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ",
                "uuid": "0c6ca6e7-e32a-4053-b824-1dbf749910d8",
                "youtube_url": "https://www.youtube.com/watch?v=6R8ffRRJcrg"
            }
        ]
    }
    """
    let networkService: NetworkService
    var recipes: [Recipe] = []
    
    init() {
        self.networkService = NetworkService.shared
        getRecipes()
    }
    
    func getRecipes() {
        let jsonDecoder = JSONDecoder()
        
        guard let jsonData = text.data(using: .utf8) else {
            print("Error converting data")
            return
        }
        
        do {
            let recipeResponse = try jsonDecoder.decode(Response.self, from: jsonData) 
            print(recipeResponse)
            self.recipes.append(contentsOf: recipeResponse.recipes)
        } catch {
            print("Error decoding JSON: \(error)")
        }
    }
    

    
    // This should be given a String and only return an optional if there is an issue getting data from the URL
    // The view calling this already knows if its Recipe has nil URLs
    // The view can send a string for either the small or large image. This should only be responsible for converting it.
    @MainActor func getImage(at urlString: String) async -> UIImage? {
        do {
            let url = try getUrl(from: urlString)
            let imageData = try await networkService.getData(from: url)
            return try getImage(from: imageData)
        } catch {
            print("Error getting image: \(error)")
            return nil
        }
    }
    
    private func getUrl(from urlString: String) throws -> URL {
        guard let url = URL(string: urlString) else {
            print("Could not convert URL from string")
            throw URLError(.badURL)
        }
        return url
    }
    
    private func getImage(from data: Data) throws -> UIImage {
        guard let image = UIImage(data: data) else {
            print("Error getting image")
            throw URLError(.badURL)
        }
        return image
    }
    
}
