//
//  CacheService.swift
//  RecipeApp
//
//  Created by Ryan Smetana on 2/16/25.
//

import SwiftUI

@MainActor 
protocol CacheManaging {
    func add(_ image: UIImage, forKey key: String) async
    func get(forKey key: String) async -> UIImage?
    func clear()
}

@MainActor
final class MemoryCacheService: CacheManaging {
    static let shared: MemoryCacheService = MemoryCacheService()
    private let cache = NSCache<NSString, UIImage>()
    
    private init() {
        cache.countLimit = 15
        // Set totalCostLimit
    }
    
    private func exists(key: NSString) async -> Bool {
        return cache.object(forKey: key) != nil
    }
    
    // NSString typically won't be used in SwiftUI. Force using String and keep NSString internal
    func add(_ image: UIImage, forKey key: String) async {
        cache.setObject(image, forKey: key as NSString)
    }
    
    func get(forKey key: String) async -> UIImage? {
        return cache.object(forKey: key as NSString)
    }
    
    func clear() {
        cache.removeAllObjects()
    }
}



