//
//  RecipeCardView.swift
//  RecipeApp
//
//  Created by Ryan Smetana on 2/16/25.
//

import SwiftUI

struct RecipeCardView: View {
    @EnvironmentObject var vm: HomeViewModel
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
                    // Show loading or placeholder for missing picture
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
            // Ensure the recipe has a non-nil url before sending it to view model
            
            guard let urlString = recipe.photoUrlSmall else { return }
            self.image = await vm.getImage(at: urlString)
        }
    }
}

#Preview {
    List {
        RecipeCardView(recipe: Recipe.mockRecipe)
            .environmentObject(HomeViewModel())
    }
}
