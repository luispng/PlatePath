//
//  MealGridView.swift
//  PlatePath
//
//  Created by Luis Paniagua on 9/14/24.
//

import SwiftUI

struct MealGridListView: View {
    @StateObject private var viewModel = MealListViewModel()
    @State private var hasLoaded: Bool = false

    let category: String

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isLoading {
                    ProgressView("Loading meals...")
                        .scaleEffect(1, anchor: .center)
                        .padding()
                } else if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.headline)
                        .padding()
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 5) {
                            ForEach(viewModel.meals, id: \.id) { meal in
                                NavigationLink(destination: MealDetailView(mealID: meal.id)) {
                                    MealGridCardView(meal: meal)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding([.leading, .trailing], 15)
                    }
                    .navigationTitle(category)
                }
            }
            .onAppear {
                if !hasLoaded {
                    viewModel.fetchMeals(forCategory: category)
                    hasLoaded = true // Mark as loaded
                }
            }
        }
    }
}

#Preview {
    MealGridListView(category: "Desert")
}
