//
//  AsyncImageLoader.swift
//  RecipeApp
//
//  Created by Ryan Smetana on 2/18/25.
//

import SwiftUI
import CryptoKit

@MainActor
final class AsyncImageLoader: ObservableObject {
    private let networkService: NetworkService
    private let memoryCacheService: CacheManaging
    private let diskCacheService: CacheManaging
    
    init(networkService: NetworkService = NetworkService.shared, 
         memoryCacheService: CacheManaging = MemoryCacheService.shared, 
         diskCacheService: CacheManaging = DiskCacheService.shared) {
        self.networkService = networkService
        self.memoryCacheService = memoryCacheService
        self.diskCacheService = diskCacheService
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
        if let memoryImage = await MemoryCacheService.shared.get(forKey: key) {
            print(key, " found in memory")
            return memoryImage
        }
        
        if let diskImage = await DiskCacheService.shared.get(forKey: key) {
            print(key, "found on disk. Saving to memory")
            await memoryCacheService.add(diskImage, forKey: key)
            return diskImage
        }
        
        if let networkImage = await downloadImage(atPath: path) {
            await MemoryCacheService.shared.add(networkImage, forKey: key)
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
