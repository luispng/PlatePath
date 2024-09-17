//
//  CategoryDetailView.swift
//  PlatePath
//
//  Created by Luis Paniagua on 9/14/24.
//

import SwiftUI

struct CategoryDetailView: View {
    @StateObject private var viewModel = CategoryDetailViewModel()
    @State private var hasLoaded: Bool = false
    
    let category: Category
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView("Loading...")
                    .padding()
            } else if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.headline)
                    .padding()
            } else {
                ScrollView {
                    VStack {
                        // Category Header
                        CategoryHeaderView(category: category)
                        
                        // Meal Grid
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                            ForEach(viewModel.meals, id: \.id) { meal in
                                NavigationLink(destination: MealDetailView(mealID: meal.id)) {
                                    MealGridCardView(meal: meal)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding([.leading, .trailing], 20)
                    }
                }
                .navigationTitle(category.name)
            }
        }
        .onAppear {
            if !hasLoaded {
                viewModel.category = category
                viewModel.fetchMeals()
                hasLoaded = true
            }
        }
    }
}

#Preview {
    let category = Category(
        id: "1",
        name: "Beef",
        thumbnail: "https://www.themealdb.com/images/category/beef.png",
        description: "Beef is the culinary name for meat from cattle...")
    return CategoryDetailView(category: category)
}
