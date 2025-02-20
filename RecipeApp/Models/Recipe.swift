//
//  Recipe.swift
//  RecipeApp
//
//  Created by Ryan Smetana on 2/16/25.
//

/*
 Sample response
 
 {
     "recipes": [
         {
             "cuisine": "British",
             "name": "Bakewell Tart",
             "photo_url_large": "https://some.url/large.jpg",           OPTIONAL
             "photo_url_small": "https://some.url/small.jpg",           OPTIONAL
             "uuid": "eed6005f-f8c8-451f-98d0-4088e2b40eb6",
             "source_url": "https://some.url/index.html",               OPTIONAL
             "youtube_url": "https://www.youtube.com/watch?v=some.id"   OPTIONAL
         },
         ...
     ]
 }
 */

import Foundation

struct Response: Codable {
    let recipes: [Recipe]
}

struct Recipe: Codable, Identifiable {
    let id: String
    let cuisine: String
    let name: String
    let photoUrlLarge : String?
    let photoUrlSmall : String?
    let sourceUrl: String?
    let youtubeUrl: String?
    
    
    enum CodingKeys: String, CodingKey {
        case id = "uuid"
        case cuisine
        case name
        case photoUrlLarge = "photo_url_large"
        case photoUrlSmall = "photo_url_small"
        case sourceUrl
        case youtubeUrl
    }
}

extension Recipe {
    static let mockRecipe = Recipe(id: "0c6ca6e7-e32a-4053-b824-1dbf749910d8", 
                                   cuisine: "Malaysian", 
                                   name: "Apam Balik", 
                                   photoUrlLarge: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg", 
                                   photoUrlSmall: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg", 
                                   sourceUrl: "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ", 
                                   youtubeUrl: "https://www.youtube.com/watch?v=6R8ffRRJcrg")
}
