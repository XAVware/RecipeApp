//
//  RecipeAppApp.swift
//  RecipeApp
//
//  Created by Ryan Smetana on 2/16/25.
//


/*
 [x] Convert URL string to UIImage
 TODO: Fetch recipes on appear
 TODO: Create ImageDataService to handle URL/data to UIImage conversion
    - Should be MainActor
 TODO: Create NetworkService to fetch JSON
 - I think this can just be a final class, probably not a MainActor
 - Might need to account for malformed or empty data.
 - This has to be done somewhere, but should it be the same class fetching data?
 TODO: Create CacheService - ifExists, get, add. I don't think this needs a delete
 TODO: Use .refreshable for refresh
 TODO: Create custom error enum to handle different cases
 
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
