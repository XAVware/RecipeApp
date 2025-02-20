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

// Cache tests suite
// Save to disk, memory, assert equal

@Suite("Async Image Loader tests") final class AsyncImageLoaderTestSuite {
    var sut: AsyncImageLoader!
    
    init() async throws {
        sut = await AsyncImageLoader()
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
}
