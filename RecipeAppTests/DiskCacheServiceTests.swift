//
//  DiskCacheServiceTests.swift
//  DiskCacheServiceTests
//
//  Created by Ryan Smetana on 2/16/25.
//

import XCTest
@testable import RecipeApp

final class DiskCacheServiceTests: XCTestCase {
    var testCacheService: DiskCacheService!
    private let fileManager = FileManager.default
    lazy var imageCacheDir: URL = {
        let cacheDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
        return cacheDirectory.appendingPathComponent("RecipeImages")
    }()
    
//    override func setUpWithError() throws {
//        // Put setup code here. This method is called before the invocation of each test method in the class.
//    }
//
//    override func tearDownWithError() throws {
//        // Put teardown code here. This method is called after the invocation of each test method in the class.
//    }
    
    override func setUp() {
        super.setUp()
        testCacheService = DiskCacheService.shared
        Task { await testCacheService.clearCache() }
        
    }
    
    override func tearDown() {
        super.tearDown()
        Task { await testCacheService.clearCache() }
    }

    func testCreatingDirectory() {
        try? fileManager.removeItem(at: imageCacheDir)

        // Shouldn't exist after being removed
        let dne = !fileManager.fileExists(atPath: imageCacheDir.path)
        XCTAssertTrue(dne)
        
        Task {
            await testCacheService.setupDirectory()
            let exists = fileManager.fileExists(atPath: imageCacheDir.path)
            XCTAssertTrue(exists)
        }
    }
    
    // TODO: I should make sure the content of the file matches the image after creating it
    func testCreatingFile() {
        let key = "dog"
        let img = UIImage(systemName: key)
        let imagePath = imageCacheDir.appendingPathComponent(key)
        
        
        Task {
            await testCacheService.add(img!, forKey: key)
            let exists = fileManager.fileExists(atPath: imagePath.path)
            XCTAssertTrue(exists)
        }
    }
    
    func testCacheImage() {
        let key = "dog"
        let img = UIImage(systemName: key)!
        let imagePath = imageCacheDir.appendingPathComponent(key)
        
//        let dne = !fileManager.fileExists(atPath: imagePath.path)
//        XCTAssertTrue(dne)
        
        Task {
            await testCacheService.add(img, forKey: key)
            let exists = fileManager.fileExists(atPath: imagePath.path)
            XCTAssertTrue(exists)
        }
    }


}
