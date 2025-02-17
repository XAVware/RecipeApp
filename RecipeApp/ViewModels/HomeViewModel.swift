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
    @Published var recipes: [Recipe] = []
    
    let cache: NSCache<NSString, UIImage>
    
    init() {
        self.networkService = NetworkService.shared
        // TODO: Move cache to its own Service
        let cache = NSCache<NSString, UIImage>()
        cache.countLimit = 15
        // TODO: Set totalCostLimit
        self.cache = cache
    }
    
    func addImageToCache(_ image: UIImage, forKey key: NSString) {
        guard cache.object(forKey: key) == nil else {
            print("Image already exists for: \(key)")
            return 
        }
        cache.setObject(image, forKey: key)
        print("Image added to cache")
    }

    func loadRecipes() async {
        // Check cache for images
    
        do {
            let recipes = try await networkService.fetchRecipes()
            self.recipes = recipes
        } catch let error as AppError {
            print(error.localizedDescription)
            return
        } catch {
            print("Unknown error occured while loading recipes")
            return 
        }
        for recipe in recipes {
            guard let urlString = recipe.photoUrlLarge else { return }
            
            await cacheImage(for: urlString)
        }
               
    }
    
    func cacheImage(for urlString: String) async {
        guard let uiImage = await getImage(at: urlString) else { return }
        addImageToCache(uiImage, forKey: NSString(string: urlString))
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
    @MainActor func getImage(at urlString: String) async -> UIImage? {
        do {
            let url = try getUrl(from: urlString)
            let imageData = try await networkService.getData(from: url)
            let uiImage = try getImage(from: imageData)
//            printSize(of: imageData)
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
    
    private func getImage(from data: Data) throws -> UIImage {
        guard let image = UIImage(data: data) else { throw AppError.invalidImageData }
        return image
    }
}
