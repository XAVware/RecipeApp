//
//  AsyncImageLoaderTests.swift
//  RecipeApp
//
//  Created by Ryan Smetana on 2/19/25.
//

import Testing
@testable import RecipeApp
import Foundation
import UIKit

@Suite("Async Image Loader tests") final class AsyncImageLoaderTestSuite {
    var sut: AsyncImageLoader!
    
    init() async throws {
        sut = await AsyncImageLoader()
        await sut.clearAllCaches()
    }
    
    @Test("Hash values match") func hashValuesMatch() async {
        let stringOne = "Hello, world"
        let stringTwo = "Hello, world"
        
        let hashOne = await sut.getHash(of: stringOne)
        let hashTwo = await sut.getHash(of: stringTwo)
        
        #expect(hashOne == hashTwo)
    }
    
    @Test("Hash values do not match") func hashValuesDoNotMatch() async {
        let stringOne = "Hello, world"
        let stringTwo = "Goodbye, world"
        
        let hashOne = await sut.getHash(of: stringOne)
        let hashTwo = await sut.getHash(of: stringTwo)
        
        #expect(hashOne != hashTwo)
    }
    
    @Test("Image successfully caches to disk") func testAddingImageToDisk() async {
        let testImageName = "dog"
        let img = UIImage(systemName: testImageName)
        
        await sut.addImageToDisk(img!, forKey: testImageName)
        let newImage = await sut.getImageFromDisk(forKey: testImageName)
        #expect(newImage != nil)
    }
    
    @Test("Image successfully caches to memory") func testAddingImageToMemory() async {
        let testImageName = "dog"
        let img = UIImage(systemName: testImageName)
        
        await sut.addImageToMemory(img!, forKey: testImageName)
        let newImage = await sut.getImageFromMemory(forKey: testImageName)
        #expect(newImage != nil)
    }
    
}
