//
//  HomeViewModel.swift
//  RecipeApp
//
//  Created by Ryan Smetana on 2/16/25.
//

import SwiftUI

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

    var recipes: [Recipe] = []
    
    init() {
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
}
