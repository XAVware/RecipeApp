//
//  DiskCacheServiceTests.swift
//  DiskCacheServiceTests
//
//  Created by Ryan Smetana on 2/16/25.
//

import XCTest
@testable import RecipeApp

final class DiskCacheServiceTests: XCTestCase {

//    override func setUpWithError() throws {
//        // Put setup code here. This method is called before the invocation of each test method in the class.
//    }
//
//    override func tearDownWithError() throws {
//        // Put teardown code here. This method is called after the invocation of each test method in the class.
//    }
    
    override func setUp() {
        
    }
    
    override func tearDown() {
        
    }

    func testCreateDirectory() {
        let fileManager = FileManager.default
        let cacheDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
        let imageCacheDirectory = cacheDirectory.appendingPathComponent("RecipeImages")
        
        try? fileManager.removeItem(at: imageCacheDirectory)
        
        // Shouldn't exist after being removed
        let dne = !fileManager.fileExists(atPath: imageCacheDirectory.path)
        XCTAssertTrue(dne)
        
        // Create and confirm exists
        try? fileManager.createDirectory(at: imageCacheDirectory, withIntermediateDirectories: true)
        let exists = fileManager.fileExists(atPath: imageCacheDirectory.path)
        XCTAssertTrue(exists)
    }


}
