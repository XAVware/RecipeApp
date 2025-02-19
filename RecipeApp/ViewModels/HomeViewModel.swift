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
    
    @Published var errorMessage: String = ""
    
    init(networkService: NetworkService = NetworkService.shared,
         imageLoader: AsyncImageLoader = AsyncImageLoader()) {
        self.networkService = NetworkService.shared
        self.imageLoader = imageLoader
    }
    
    /// Initialize recipe array when app starts
    func fetchRecipes() async {   
        self.errorMessage = ""
        self.isLoading = true
        defer { isLoading = false }
        
        do {
            let recipes = try await networkService.fetchRecipes()
            self.recipes = recipes
        } catch let error as AppError {
            // Edge case: Two errors have the same localized description
            if error.localizedDescription == AppError.malformedResponse.localizedDescription {
                displayError(message: "Unable to download recipes, please try again in a few seconds.")
                recipes.removeAll()
            }
            return
        } catch {
            displayError(message: "Unknown error occured while loading recipes")
            return 
        }
    }
    
    func displayError(message: String) {
        errorMessage = message
        Task(priority: .background) {
            try? await Task.sleep(for: .seconds(4))
            errorMessage = ""
        }
    }
}


