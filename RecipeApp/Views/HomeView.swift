//
//  HomeView.swift
//  RecipeApp
//
//  Created by Ryan Smetana on 2/16/25.
//

import SwiftUI

// TODO: Display message for empty recipe list
struct HomeView: View {
    @StateObject var vm: HomeViewModel
    @StateObject var imageLoader: AsyncImageLoader
    
    init() {
        let networkService = NetworkService.shared
        let imageLoader = AsyncImageLoader(networkService: networkService)
        self._imageLoader = StateObject(wrappedValue: imageLoader)
        self._vm = StateObject(wrappedValue: HomeViewModel(networkService: networkService, imageLoader: imageLoader))
    }
    var body: some View {
        ZStack {
            List(vm.recipes) { recipe in
                RecipeCardView(recipe: recipe)
                    .environmentObject(imageLoader)
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

