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
    
    var body: some View {
        VStack(alignment: .center) {
            Group {
                if let image = image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                } else {
                    ProgressView()
                        .task {
                            guard let path = recipe.photoUrlSmall else { return }
                            self.image = await vm.loadImage(atPath: path)
                        }
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
    }
}

#Preview {
    List {
        RecipeCardView(recipe: Recipe.mockRecipe)
            .environmentObject(HomeViewModel())
    }
}
