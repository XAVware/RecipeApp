//
//  HomeView.swift
//  RecipeApp
//
//  Created by Ryan Smetana on 2/16/25.
//

/*
 
 When the view appears, check cache or fetch images
 
 */


import SwiftUI
// TODO: Fetch recipes on appear
// TODO: Use .refreshable for refresh

struct HomeView: View {
    @State var vm: HomeViewModel = HomeViewModel()
    
    var body: some View {
        List(vm.recipes) { recipe in
            VStack(alignment: .center) {
                Image("tempPhoto")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 180)
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                
                HStack {
                    Text(recipe.cuisine)
                    Spacer()
                    Text(recipe.name)
                } //: HStack
                .padding()
            }
        } //: List
        .padding()
    }
}

#Preview {
    HomeView()
}
