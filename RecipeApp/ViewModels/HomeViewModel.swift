//
//  HomeViewModel.swift
//  RecipeApp
//
//  Created by Ryan Smetana on 2/16/25.
//

import SwiftUI

/* 
 Use the following to decide what to set totalCostLimit to
 
 Recipe large UIImages total 1350548 bytes or 1.350548 Mb
 Recipe small UIImages total 86890 bytes or 0.08689 Mb
 */

@MainActor
class HomeViewModel: ObservableObject {
    private let networkService: NetworkService
    private let sessionCacheService: SessionCacheService
    
    @Published var recipes: [Recipe] = []
    
    
    @Published var isLoading: Bool = false
    
    init() {
        self.networkService = NetworkService.shared
        self.sessionCacheService = SessionCacheService.shared
    }
    
    /// Initialize recipe array when app starts
    func initializeRecipes() async {   
        self.isLoading = true
        defer { isLoading = false }
        
        do {
            let recipes = try await networkService.fetchRecipes()
            self.recipes = recipes
        } catch let error as AppError {
            // TODO: Handle malformed recipes.
            print(error.localizedDescription)
            return
        } catch {
            print("Unknown error occured while loading recipes")
            return 
        }
        
//        for recipe in recipes {
//            guard let urlString = recipe.photoUrlLarge else { return }
//            await cacheImage(for: urlString)
//        }
               
    }
    
    var imageSizes: Int = 0
    func printSize(of data: Data) {
        let imageData = NSData(data: data)
        let imageSize: Int = imageData.count
        imageSizes += imageSize
        print(imageSizes)
    }
    
    // This should be given a String and only return an optional if there is an issue getting data from the URL
    // The view calling this already knows if its Recipe has nil URLs
    // The view can send a string for either the small or large image. This should only be responsible for converting it.
    @MainActor func downloadImage(at urlString: String) async -> UIImage? {
        do {
            let url = try getUrl(from: urlString)
            let imageData = try await networkService.getData(from: url)
            let uiImage = try getImage(from: imageData)
//            printSize(of: imageData)
//            await sessionCacheService.set(uiImage, forKey: urlString)
            return uiImage
        } catch {
            print("Error getting image: \(error)")
            return nil
        }
    }
    
    private func getUrl(from urlString: String) throws -> URL {
        guard let url = URL(string: urlString) else { throw AppError.invalidUrlString }
        return url
    }
    
    /// Returns a UIImage from the given Data
    private func getImage(from data: Data) throws -> UIImage {
        guard let image = UIImage(data: data) else { throw AppError.invalidImageData }
        return image
    }
}
