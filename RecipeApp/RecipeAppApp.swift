//
//  RecipeAppApp.swift
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
 
 
 Project plan:
 - Start with the model, make codable and ensure this sample JSON decodes properly
 - NetworkService for fetching JSON
    - Might need to account for malformed or empty data
 - Possibly another service to fetch the image data from URL - this would keep the image conversion logic separate from the JSON fetching logic
 - CachingService to cache Image (or data) from URL.
 
 */




import SwiftUI

@main
struct RecipeAppApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView()
        }
    }
}
