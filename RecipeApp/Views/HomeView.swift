//
//  HomeView.swift
//  RecipeApp
//
//  Created by Ryan Smetana on 2/16/25.
//

import SwiftUI

// TODO: Display message for empty recipe list
struct HomeView: View {
    @StateObject var vm: HomeViewModel = HomeViewModel()
    
    var body: some View {
        ZStack {
            List(vm.recipes) { recipe in
                RecipeCardView(recipe: recipe)
            } //: List
            .padding()
            .refreshable(action: vm.initializeRecipes)
            .task {
                await vm.initializeRecipes()
            }
            .overlay(
                Label("Pull down to refresh", systemImage: "arrow.counterclockwise")
                    .font(.caption2)
                , alignment: .top
            )
            .environmentObject(vm)
            
            if vm.isLoading {
                // TODO: Improve this later
                ProgressView()
            }
        } //: ZStack
    } //: Body
}

#Preview {
    HomeView()
}

