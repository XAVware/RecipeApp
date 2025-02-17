//
//  RecipeAppApp.swift
//  RecipeApp
//
//  Created by Ryan Smetana on 2/16/25.
//


/*
 [x] Convert URL string to UIImage
 [x] Fetch recipes on appear
 [x] Move image conversion logic into the view model.
 [x] Create NetworkService to fetch JSON
 - I think this can just be a final class, probably not a MainActor
     - Might need to account for malformed or empty data.
         - This has to be done somewhere, but should it be the same class fetching data?
 [x] Create custom error enum to handle different cases
 [x] Use .refreshable for refresh
 TODO: Create CacheService - ifExists, get, add. I don't think this needs a delete
 TODO: Handle operating system versions back to iOS 16
 TODO: Display state of loading
 TODO: Error occuring while fetching small images
 
 
 
 
 Image data vs. NetworkService
 
 If network service is intended to handle all network activity, there are parts of the image conversion process that belong in it. 
    - Getting data from the URL

 This would leave the original idea of an image service doing barely anything.
 
 The remaining image conversion functions should probably just go in the view model since it's already a MainActor
 
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
