//
//  DiskCacheService.swift
//  RecipeApp
//
//  Created by Ryan Smetana on 2/18/25.
//

import SwiftUI

@MainActor
final class DiskCacheService: CacheManaging {
    static let shared: DiskCacheService = DiskCacheService()
    
    private let fileManager = FileManager.default
    lazy var imageCacheDirectory: URL = {
        fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
    }()
    
    private init() {
        setupDirectory()
    }
    
    // Should be private, but for the sake of making the original test work in this project...
    func setupDirectory() {
        if !fileManager.fileExists(atPath: imageCacheDirectory.path) {
            print("Creating cache directory")
            do {
                try fileManager.createDirectory(at: imageCacheDirectory, withIntermediateDirectories: true)
            } catch {
                print("Error creating disk directory: \(error)")
            }
        }
    }
    
    func get(forKey key: String) async -> UIImage? {
        let filePath = imageCacheDirectory.appendingPathComponent(key)
        if let data = fileManager.contents(atPath: filePath.path) {
            let image = UIImage(data: data)
            return image
        }
        return nil
    }
    
    func add(_ image: UIImage, forKey key: String) async {
        let imagePath = imageCacheDirectory.appendingPathComponent(key)
        fileManager.createFile(atPath: imagePath.path, contents: image.jpegData(compressionQuality: 0))
    }
    
    func clear() {
        do {
            // Get the directory contents urls (including subfolders urls)
            let cachedImagePaths = try FileManager.default.contentsOfDirectory( at: imageCacheDirectory, includingPropertiesForKeys: nil, options: [])
            try cachedImagePaths.forEach({ try deleteFile(atPath: $0.path) })
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    private func deleteFile(atPath path: String) throws {
        try fileManager.removeItem(atPath: path)
    }
    
}
