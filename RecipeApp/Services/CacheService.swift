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
@MainActor
final class NSCacheService {
    static let shared: NSCacheService = NSCacheService()
    private let cache = NSCache<NSString, UIImage>()
    
    private init() {
        cache.countLimit = 15
        // Set totalCostLimit
    }
    
    private func set(_ image: UIImage, forKey key: NSString) async {
        cache.setObject(image, forKey: key)
    }
    
    private func getObj(forKey key: NSString) async -> UIImage? {
        let image = cache.object(forKey: key)
        return image
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
    
    func clearCache() {
        cache.removeAllObjects()
    }
}



