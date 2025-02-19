//
//  HomeViewModel.swift
//  RecipeApp
//
//  Created by Ryan Smetana on 2/16/25.
//

import SwiftUI
import CryptoKit
/* 
 Use the following to decide what to set totalCostLimit to
 
 Recipe large UIImages total 1350548 bytes or 1.350548 Mb
 Recipe small UIImages total 86890 bytes or 0.08689 Mb
 */

@MainActor
class HomeViewModel: ObservableObject {
    private let networkService: NetworkService
    private let imageLoader: AsyncImageLoader
    
    @Published var recipes: [Recipe] = []
    @Published var isLoading: Bool = false
    
    init(networkService: NetworkService = NetworkService.shared,
         imageLoader: AsyncImageLoader = AsyncImageLoader()) {
        self.networkService = NetworkService.shared
        self.imageLoader = imageLoader
    }
    
    /// Initialize recipe array when app starts
    func initializeRecipes() async {   
        self.isLoading = true
        defer { isLoading = false }
        
        do {
            let recipes = try await networkService.fetchRecipes()
            self.recipes = recipes
        } catch let error as AppError {
            // TODO: Handle malformed recipes.
            print(error.localizedDescription)
            return
        } catch {
            print("Unknown error occured while loading recipes")
            return 
        }
    }
}

// For checking the data returned from `networkService.getData(from: url)`
extension HomeViewModel {
    func printSize(of data: Data) {
        var imageSizes: Int = 0
        let imageData = NSData(data: data)
        let imageSize: Int = imageData.count
        imageSizes += imageSize
        print(imageSizes)
    }
}
