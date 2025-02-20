//
//  DiskCacheServiceTests.swift
//  DiskCacheServiceTests
//
//  Created by Ryan Smetana on 2/16/25.
//

/*
 
 For this project I'm leaving all tests in this single file. Some are related to caching services, some are related to the view model. In a production project there would be multiple files encapsulating each different piece of the app.
 */

/*
 Sample response
 
 {
 "recipes": [
 {
 "cuisine": "British",
 "name": "Bakewell Tart",
 "photo_url_large": "https://some.url/large.jpg",           OPTIONAL
 "photo_url_small": "https://some.url/small.jpg",           OPTIONAL
 "uuid": "eed6005f-f8c8-451f-98d0-4088e2b40eb6",
 "source_url": "https://some.url/index.html",               OPTIONAL
 "youtube_url": "https://www.youtube.com/watch?v=some.id"   OPTIONAL
 },
 ...
 ]
 }
 */

import XCTest
@testable import RecipeApp

final class DiskCacheServiceTests: XCTestCase {
    var testMemoryCacheService: MemoryCacheService!
    var testDiskCacheService: DiskCacheService!
    private let fileManager = FileManager.default
    lazy var imageCacheDir: URL = {
        let cacheDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
        return cacheDirectory.appendingPathComponent("RecipeImages")
    }()
    
    override func setUp() {
        super.setUp()
        testDiskCacheService = DiskCacheService.shared
        testMemoryCacheService = MemoryCacheService.shared
        Task { 
            await testDiskCacheService.clear()
            await testMemoryCacheService.clear()
        }
        
    }
    
    override func tearDown() {
        super.tearDown()
        Task { 
            await testDiskCacheService.clear()
            await testMemoryCacheService.clear()
        }
    }

    func testCreatingDiskDirectory() {
        try? fileManager.removeItem(at: imageCacheDir)

        // Shouldn't exist after being removed
        let dne = !fileManager.fileExists(atPath: imageCacheDir.path)
        XCTAssertTrue(dne)
        
        Task {
            await testDiskCacheService.setupDirectory()
            let exists = fileManager.fileExists(atPath: imageCacheDir.path)
            XCTAssertTrue(exists)
        }
    }
    
    // TODO: I should make sure the content of the file matches the image after creating it
    func testAddingImageToDisk() {
        let key = "dog"
        let img = UIImage(systemName: key)
        let imagePath = imageCacheDir.appendingPathComponent(key)
        
        
        Task {
            await testDiskCacheService.add(img!, forKey: key)
            let exists = fileManager.fileExists(atPath: imagePath.path)
            XCTAssertTrue(exists)
        }
    }
    
    /*
     This test should really be broken into multiple tests, but for this project I'm leaving in one.
     */
    
    func testDownloadingImageAndCacheToDiskAndMemory() {
        let urlPath = "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg"
        let originalImage = UIImage(systemName: "dog")!
        
        Task {
            let vm = await AsyncImageLoader()
            let key = await vm.getHash(of: urlPath)
            
            // Clear the caches and make sure the image doesn't exist in either
            await testMemoryCacheService.clear()
            await testDiskCacheService.clear()
            
            let nilMemoryImage = await testMemoryCacheService.get(forKey: key)
            XCTAssertNil(nilMemoryImage)
            
            let nilDiskImage = await testDiskCacheService.get(forKey: key)
            XCTAssertNil(nilDiskImage)
            
            
            // Load the image - it should download from the network and cache to memory and disk
            let img = await vm.loadImage(atPath: urlPath)
            
            XCTAssertNotNil(img)
            XCTAssertEqual(img, originalImage)
            
            // Check memory and disk to make sure they saved
            let memoryImage = await testMemoryCacheService.get(forKey: key)
            XCTAssertNotNil(memoryImage)
            
            let diskImage = await testDiskCacheService.get(forKey: key)
            XCTAssertNotNil(diskImage)
            
            XCTAssertEqual(memoryImage, originalImage)
            XCTAssertEqual(diskImage, originalImage)
            
            // The following lines should be isolated away from the network call. For the case of this project I'm going to run them as is and confirm the console does not log network activity.
            
            // Delete memory and make sure image pulls from disk
            await testMemoryCacheService.clear()
            
            let memoryImage2 = await vm.loadImage(atPath: urlPath)
            XCTAssertNotNil(memoryImage2)
            XCTAssertEqual(memoryImage2, originalImage)
        }
    }


}

