//
//  CacheService.swift
//  RecipeApp
//
//  Created by Ryan Smetana on 2/16/25.
//

import SwiftUI

// If this app were larger scale this could be reused, not specifically for images
// TODO: Make more generic
// TODO: Check if this should be main actor

//@MainActor 
//protocol CacheManaging {
//    func set(_ image: UIImage, forKey key: NSString) async
//    func set(_ image: UIImage, forKey key: String) async
//    func getObj(forKey key: NSString) async -> UIImage?
//    func getObj(forKey key: String) async -> UIImage?
//}

final class SessionCacheService {

    
    @MainActor static let shared: SessionCacheService = SessionCacheService()
    private let cache = NSCache<NSString, UIImage>()
    
    private init() {
        cache.countLimit = 15
        // Set totalCostLimit
    }
    
    private func set(_ image: UIImage, forKey key: NSString) async {
        cache.setObject(image, forKey: key)
    }
    
    private func getObj(forKey key: NSString) async -> UIImage? {
        cache.object(forKey: key)
    }
    
    private func exists(key: NSString) async -> Bool {
        return cache.object(forKey: key) != nil
    }
    
    // NSString typically won't be used in SwiftUI. Force using String and keep NSString internal
    func set(_ image: UIImage, forKey key: String) async {
        let nStr = NSString(string: key)
        await self.set(image, forKey: nStr)
    }
    
    func getObj(forKey key: String) async -> UIImage? {
        let nStr = NSString(string: key)
        return await self.getObj(forKey: nStr)
    }
}


@MainActor
final class DiskCacheService {
    static let shared: DiskCacheService = DiskCacheService()
    
    private let fileManager = FileManager.default
    lazy var imageCacheDirectory: URL = {
        let cacheDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
        return cacheDirectory.appendingPathComponent("RecipeImages")
    }()
    
    private init() {
        setupDirectory()
    }
    
    func setupDirectory() {
        if !fileManager.fileExists(atPath: imageCacheDirectory.path) {
            do {
                try fileManager.createDirectory(at: imageCacheDirectory, withIntermediateDirectories: true)
            } catch {
                print("Error creating disk directory: \(error)")
            }
        }
    }
    
    func clearCache() {
        do {
            let cachedImagePaths = try fileManager.contentsOfDirectory(atPath: imageCacheDirectory.path)
            cachedImagePaths.forEach({ deleteFile(atPath: $0) })
        } catch {
            print("Error clearing disk cache: \(error)")
            return
        }
    }
    
    private func deleteFile(atPath path: String) {
        try? fileManager.removeItem(atPath: path)
    }
    
    func getObj(forKey key: String) async -> UIImage? {
        let filePath = imageCacheDirectory.appendingPathComponent(key)
        if let data = fileManager.contents(atPath: filePath.path) {
            // This is going to return an optional image even if the image exists... okay?
            let image = UIImage(data: data)
            return image
        }
        return nil
    }
    
    func add(_ image: UIImage, forKey key: String) async {
        let imagePath = imageCacheDirectory.appendingPathComponent(key)
        
        fileManager.createFile(atPath: imagePath.path, contents: image.jpegData(compressionQuality: 0))
        print("Image cached to disk")
    }
}
