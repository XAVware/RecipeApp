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
    
    @State var isShowingAlert: Bool = false
    @State var errorMessage: String = ""
    
    @State var alertOffset: CGFloat = -180
    
    init() {
        let networkService = NetworkService.shared
        let imageLoader = AsyncImageLoader(networkService: networkService)
        self._imageLoader = StateObject(wrappedValue: imageLoader)
        self._vm = StateObject(wrappedValue: HomeViewModel(networkService: networkService, imageLoader: imageLoader))
    }
    
    var body: some View {
        ZStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading) {
                    
                    if #available(iOS 16.1, *) { 
                        Text("Recipes")
                            .font(.title)
                            .fontWeight(.semibold)
                            .fontDesign(.rounded)
                            .padding(.horizontal)
                    } else {
                        Text("Recipes")
                            .font(.title)
                            .fontWeight(.semibold)
                            .padding(.horizontal)
                    }
                                                
                    recipeCardCarousel
                } //: VStack
                .padding(.vertical)
            }
            .refreshable {
                Task {
                    await vm.fetchRecipes()
                }
            }
            .task {
//                await vm.fetchRecipes(from: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json") // Empty
//                await vm.fetchRecipes(from: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json") // Malformed
                await vm.fetchRecipes()
            }
            .overlay(
                Label("Pull down to refresh", systemImage: "arrow.counterclockwise")
                    .font(.caption2)
                    .opacity(0.2)
                , alignment: .top
            )
            
            if vm.isLoading {
                ProgressView()
            }
            
            VStack {
                alertView 
                    .offset(y: alertOffset)
                Spacer()
            }
            .onReceive(vm.$errorMessage) { message in
                message.isEmpty ? hideAlert() : showAlert()
            }
        } //: ZStack 
    } //: Body
    
    @ViewBuilder private var recipeCardCarousel: some View {
        if !vm.recipes.isEmpty {
            ScrollView(.horizontal, showsIndicators: false) { 
                LazyHStack(spacing: 0) { 
                    ForEach(vm.recipes) { recipe in 
                        RecipeCardView(recipe: recipe)
                            .environmentObject(imageLoader)
                    }
                } //: LazyHStack
            } //: ScrollView
        } else {
            VStack {
                Image(systemName: "arrow.counterclockwise")
                    .resizable()
                    .scaledToFit() 
                    .frame(maxWidth: 56)
                    .opacity(0.4)
                    .padding()
                
                Text("No recipes found, please try again.")
                    .frame(maxWidth: .infinity)
               
            }
            .padding(.vertical)
            
        }
    }
    
    @ViewBuilder private var alertView: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Image(systemName: "exclamationmark.circle")
                Text("Uh oh, something went wrong")
                    .font(.subheadline)
            } //: HStack
            .fontWeight(.semibold)
            
            Text(vm.errorMessage)
                .font(.caption) 
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(height: 42)
                .padding(.horizontal, 4)
        } //: VStack
        .padding(8)
        .background(
            Color.alertBackground
                .clipShape(RoundedRectangle(cornerRadius: 8))
        )
        .padding(.horizontal)
    }
    
    // MARK: - Functions
    
    func showAlert() {
        withAnimation(.easeIn(duration: 0.1)) { 
            alertOffset = 0            
        }   
    }
    
    func hideAlert() {
        withAnimation(.easeIn(duration: 0.1)) { 
            alertOffset = -180          
        }   
    }
}

#Preview {
    HomeView()
}

