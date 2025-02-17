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
        ZStack {
            List(vm.recipes) { recipe in
                RecipeCardView(recipe: recipe)
            } //: List
            .padding()
            .refreshable(action: vm.loadRecipes)
            .task {
                await vm.loadRecipes()
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
        }
    } //: Body
}

#Preview {
    HomeView()
}

