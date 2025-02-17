//
//  HomeViewModel.swift
//  RecipeApp
//
//  Created by Ryan Smetana on 2/16/25.
//

import SwiftUI



@MainActor
class HomeViewModel: ObservableObject {
    private let networkService: NetworkService
    @Published var recipes: [Recipe] = []
    
    init() {
        self.networkService = NetworkService.shared
    }

    func loadRecipes() async {
        // Check cache for images
        
        // If cache does not contain images
        do {
            let recipes = try await networkService.fetchRecipes()
            self.recipes = recipes
        } catch let error as AppError {
            print(error.localizedDescription)
            return
        } catch {
            print("Unknown error occured while loading recipes")
            return 
        }
    }
    
    // This should be given a String and only return an optional if there is an issue getting data from the URL
    // The view calling this already knows if its Recipe has nil URLs
    // The view can send a string for either the small or large image. This should only be responsible for converting it.
    @MainActor func getImage(at urlString: String) async -> UIImage? {
        do {
            let url = try getUrl(from: urlString)
            let imageData = try await networkService.getData(from: url)
            return try getImage(from: imageData)
        } catch {
            print("Error getting image: \(error)")
            return nil
        }
    }
    
    private func getUrl(from urlString: String) throws -> URL {
        guard let url = URL(string: urlString) else { throw AppError.invalidUrlString }
        return url
    }
    
    private func getImage(from data: Data) throws -> UIImage {
        guard let image = UIImage(data: data) else { throw AppError.invalidImageData }
        return image
    }
}
