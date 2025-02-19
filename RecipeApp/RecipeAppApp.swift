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
 [x] Create custom error enum to handle different cases
 [x] Use .refreshable for refresh
 [x] each recipe should show its name, photo, and cuisine type
 
 

 
 Views
 [x] Display state of loading
 TODO: If the recipes list is empty, the app should display an empty state to inform users that no recipes are available.
 - This can probably be done in the View itself
 TODO: Make sure refresh is working with the cache 
 TODO: Load images only when needed in the UI to avoid unnecessary bandwidth consumption. Cache images to disk to minimize repeated network requests
     - Only mentions images, no need to cache JSON responses.
     - Load images as needed in the UI via NSCache because these are session based and will help UI performance; Cache images to disk so once the app closes/re opens the image can be fetched without relying on a network request
 
 1. View appears, fetch called.
 2. JSON downloaded, encoded, and stored in [Recipe]
 3. Recipe list appears, URL should be passed to a RecipeImageView which calls fetchImage.
 4. Fetch Image; For this case I'm going to pull from the NS Cache first since this is more closely tied to the UI.
     1. Pass URL to NSCache service, get image if exists, if not then continue;
     2. Pass URL to FileManagerCache/Disk service, get image if exists, if not then download through NetworkService and cache in both NSCache and FileManager
 
 
 Cache
 [x] Create CacheManaging protocol - exists, get, add
 [x] Create DiskCacheService (FileManager)
 [x] Create SessionCacheService (NSCache)
 
 
 Errors/Cases
 TODO: If a recipe is malformed, your app should disregard the entire list of recipes and handle the error gracefully.
 TODO: Error occuring while fetching small images


 Tests
 TODO: Test JSON decoding
 [x] Test CacheManaging protocol functions
 TODO: Test proper AppError casting
 
 Before production
 TODO: Handle operating system versions back to iOS 16
 [x] Make sure all image loading is using async/await

 
 Future:
 TODO: Make cache services more generic, if this app were larger scale this could be reused, not specifically for images
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
