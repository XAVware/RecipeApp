//
//  HomeViewModel.swift
//  RecipeApp
//
//  Created by Ryan Smetana on 2/16/25.
//

import SwiftUI
import CryptoKit
/* 
 Use the following to decide what to set totalCostLimit to
 
 Recipe large UIImages total 1350548 bytes or 1.350548 Mb
 Recipe small UIImages total 86890 bytes or 0.08689 Mb
 */

@MainActor
class HomeViewModel: ObservableObject {
    private let networkService: NetworkService
    private let memoryCacheService: NSCacheService
    private let diskCacheService: DiskCacheService
    
    @Published var recipes: [Recipe] = []
    @Published var isLoading: Bool = false
    
    init() {
        self.networkService = NetworkService.shared
        self.memoryCacheService = NSCacheService.shared
        self.diskCacheService = DiskCacheService.shared
        
        diskCacheService.clearCache()
        memoryCacheService.clearCache()
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
    }
    
    func getHash(of val: String) -> String {
        return SHA256.hash(data: val.data(using: .utf8)!)
            .compactMap { String(format: "%02x", $0) }
            .joined()
    }
    
    /*
     1. Check memory because it is more coupled to the UI than disk cache
     e.g. The cache should only contain images that have already appeared on screen whereas the disk cache could contain images from a previous session.
     
     2. Check disk
     3. Download from web
     */
    @MainActor 
    func loadImage(atPath path: String) async -> UIImage? {
        let key = getHash(of: path)
                 
        // Check if image exists in cache, if not download then save to cache
        if let memoryImage = await NSCacheService.shared.getObj(forKey: key) {
            print(key, " found in memory")
            return memoryImage
        }

        if let diskImage = await DiskCacheService.shared.getObj(forKey: key) {
            print(key, "found on disk. Saving to memory")
            await memoryCacheService.set(diskImage, forKey: key)
            return diskImage
        }
        
        if let networkImage = await downloadImage(atPath: path) {
            await NSCacheService.shared.set(networkImage, forKey: key)
            await DiskCacheService.shared.add(networkImage, forKey: key)
            print("< NETWORK > ", key, " downloaded and saved to memory and disk")
            return networkImage
        }
        
        print("< ERROR > No image found")
        return nil
    } 
    

    /*
     Called from RecipeCardView. The View only displays the image if it's not optional
     This should be given a String and return an optional image
     
     Move caching logic somewhere else
     */
    /// Tries to convert the given URL string into a UIImage by fetching the URL's data from the network.
    @MainActor 
    func downloadImage(atPath urlString: String) async -> UIImage? {
        do {
            let imageData = try await networkService.getData(from: urlString)
            let uiImage = try getImage(from: imageData)
            return uiImage
        } catch {
            print("Error getting image: \(error)")
            return nil
        }
    }
    
    
    
    /// Returns a UIImage from the given Data
    private func getImage(from data: Data) throws -> UIImage {
        guard let image = UIImage(data: data) else { throw AppError.invalidImageData }
        return image
    }
}

// For checking the data returned from `networkService.getData(from: url)`
extension HomeViewModel {
    func printSize(of data: Data) {
        var imageSizes: Int = 0
        let imageData = NSData(data: data)
        let imageSize: Int = imageData.count
        imageSizes += imageSize
        print(imageSizes)
    }
}
