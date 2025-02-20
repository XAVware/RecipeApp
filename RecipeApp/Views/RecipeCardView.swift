//
//  RecipeCardView.swift
//  RecipeApp
//
//  Created by Ryan Smetana on 2/16/25.
//

import SwiftUI

struct RecipeCardView: View {
    @EnvironmentObject var vm: AsyncImageLoader
    @State var recipe: Recipe
    
    @State var image: UIImage?
    @State var isFavorite: Bool = false
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Group {
                if let image = image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                } else {
                    ProgressView()
                        .task {
                            guard let path = recipe.photoUrlSmall else { return }
                            self.image = await vm.loadImage(atPath: path)
                        }
                }
            } //: Group
            .clipShape(RoundedRectangle(cornerRadius: 4))
            
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(recipe.cuisine)
                        .font(.subheadline) 
                    Spacer()
                    Button("", systemImage: isFavorite ? "heart.fill" : "heart") { 
                        withAnimation(.bouncy) {
                            isFavorite.toggle()
                        }
                        // Cache through DiskCacheService in 'favorites' folder
                    }
                    .foregroundStyle(.pink)
                    .labelStyle(.iconOnly)
                }
                Text(recipe.name)
                    .font(.caption)
                    .opacity(0.8)
                    .frame(height: 36, alignment: .top)
            } //: VStack
        } //: VStack
        .frame(width: 120)
        .padding(12)
    }
}

#Preview {
    List {
        RecipeCardView(recipe: Recipe.mockRecipe)
            .environmentObject(HomeViewModel())
    }
}
