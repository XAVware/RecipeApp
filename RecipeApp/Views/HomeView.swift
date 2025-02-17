//
//  HomeView.swift
//  RecipeApp
//
//  Created by Ryan Smetana on 2/16/25.
//

import SwiftUI

struct HomeView: View {
    @StateObject var vm: HomeViewModel = HomeViewModel()
    
    var body: some View {
        List(vm.recipes) { recipe in
            RecipeCardView(recipe: recipe)
        } //: List
        .padding()
        .task {
            await vm.loadRecipes()
        }
        .environmentObject(vm)
    } //: Body
}

#Preview {
    HomeView()
}

