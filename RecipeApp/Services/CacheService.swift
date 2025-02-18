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
    
    func set(_ image: UIImage, forKey key: NSString) async {
        cache.setObject(image, forKey: key)
    }
    
    func getObj(forKey key: NSString) async -> UIImage? {
        cache.object(forKey: key)
    }
    
    private func exists(key: NSString) async -> Bool {
        return cache.object(forKey: key) != nil
    }
    
    // Helper functions offering the option to pass a String instead of NSString
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
    
//    func getObj(forKey key: NSString) async -> UIImage? {
//        guard fileManager.fileExists(atPath: key) else {
//            return nil
//        }
//    }
//    
//    func set(_ image: UIImage, forKey key: NSString) async {
//        if !fileManager.fileExists(atPath: filePath) {
//            let contents = Data()
//            fileManager.createFile(atPath: filePath, contents: contents)
//            
//        } else {
//            print("File \(filePath) already exists")
//        }
//    }
}
