//
//  CacheServiceTest.swift
//  RecipeApp
//
//  Created by Ryan Smetana on 2/19/25.
//

import Testing
@testable import RecipeApp
import Foundation
import UIKit

// Cache tests suite
// Save to disk, memory, assert equal

@Suite("Cache service tests") final class CacheServiceTestSuite {
    private let fileManager = FileManager.default
    private var testMemoryCacheService: MemoryCacheService!
    private var testDiskCacheService: DiskCacheService!
    private let imageCacheDir = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!.appendingPathComponent("RecipeImages")
    private let validImageUrl = "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg"
    
    private let originalImage = UIImage(systemName: "dog")!
    
    init() async {
        testDiskCacheService = await DiskCacheService.shared
        testMemoryCacheService = await MemoryCacheService.shared
        await testDiskCacheService.clear()
        await testMemoryCacheService.clear()
    }
    
    @Test("Directory is created when not found") func testCreatingDiskDirectory() async {
        try? fileManager.removeItem(at: imageCacheDir)
        
        // Shouldn't exist after being removed
        let dne = !fileManager.fileExists(atPath: imageCacheDir.path)
        #expect(dne)
        
        await testDiskCacheService.setupDirectory()
        let exists = fileManager.fileExists(atPath: imageCacheDir.path)
        #expect(exists)
    }
    
    @Test("Image successfully caches to disk") func testAddingImageToDisk() async {
        let key = "dog"
        let img = UIImage(systemName: key)
        let imagePath = imageCacheDir.appendingPathComponent(key)
        
        let preVal = fileManager.fileExists(atPath: imagePath.path)
        #expect(!preVal)
        
        await testDiskCacheService.add(img!, forKey: key)
        let exists = fileManager.fileExists(atPath: imagePath.path)
        #expect(exists)
        
    }
    
    
    
    
}
