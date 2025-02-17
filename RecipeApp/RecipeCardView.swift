//
//  RecipeCardView.swift
//  RecipeApp
//
//  Created by Ryan Smetana on 2/16/25.
//

import SwiftUI

struct RecipeCardView: View {
    @State var recipe: Recipe
    
    @State var image: UIImage?
    
    var body: some View {
        VStack(alignment: .center) {
            Group {
                if let image = image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                } else {
                    // Show loading
                }
            } //: Group
                .frame(width: 180)
                .clipShape(RoundedRectangle(cornerRadius: 18))
            
            HStack {
                Text(recipe.cuisine)
                Spacer()
                Text(recipe.name)
            } //: HStack
            .padding()
        } //: VStack
        .task {
            guard let urlString = recipe.photoUrlLarge else {
                print("No url string")
                return
            }
            
            guard let url = URL(string: urlString) else {
                print("Could not get URL from string")
                return
            }
            
            do {
                let imageData = try await getData(from: url)
                self.image = try getImage(from: imageData)
            } catch {
                print("Error getting image: \(error)")
            }
        }
    }
    
    // TODO: These should be moved to an ImageConverter service
    /// Fetch data response from a URL
    func getData(from url: URL) async throws -> Data {
        let data = try await URLSession.shared.data(from: url)
        return data.0
    }
    
    func getImage(from data: Data) throws -> UIImage {
        guard let image = UIImage(data: data) else {
            print("Error getting image")
            throw URLError(.badURL)
        }
        return image
    }
}

#Preview {
    List {
        RecipeCardView(recipe: Recipe.mockRecipe)
    }
}
