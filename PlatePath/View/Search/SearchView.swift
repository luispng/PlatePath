//
//  Search.swift
//  PlatePath
//
//  Created by Luis Paniagua on 9/17/24.
//

import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel = SearchViewModel()
    @State private var selectedMeal: Meal?
    @State private var navigateToDetail: Bool = false

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                contentView
            }
            .navigationTitle("Search")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $viewModel.searchTerm, placement: .navigationBarDrawer(displayMode: .always))
            .disableAutocorrection(true)
            .onChange(of: viewModel.searchTerm) { _ in
                viewModel.performSearch(debounce: true)
            }
            .onSubmit(of: .search) {
                viewModel.performPendingSearchNow()
            }
            .background(
                // allows customization of table row selection style
                NavigationLink(destination: MealDetailView(mealID: selectedMeal?.id ?? ""), isActive: $navigateToDetail) {
                    EmptyView()
                }
                    .hidden()
            )
        }
    }

    // Content View
    private var contentView: some View {
        Group {
            if viewModel.isTyping || viewModel.isLoading {
                loadingStateView
            } else if let errorMessage = viewModel.errorMessage  {
                errorView(errorMessage)
            } else if viewModel.meals.isEmpty && !viewModel.isLoading {
                emptyStateView
            } else {
                resultTableView
            }
        }
    }

    // Error View
    private func errorView(_ message: String) -> some View {
        VStack {
            Text(message)
                .foregroundColor(.red)
                .font(.headline)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
            Spacer()
        }
        .padding()
    }

    // Loading State View
    private var loadingStateView: some View {
        VStack {
            HStack{
                ProgressView()
                Text("Searching...")
                    .foregroundColor(.gray)
                    .font(.subheadline)
                    .padding()
            }
            Spacer()
        }
        .padding()
    }

    // Empty State View
    private var emptyStateView: some View {
        VStack {
            Text("Start typing to search for meals...")
                .foregroundColor(.gray)
                .font(.subheadline)
                .padding()
            Spacer()
        }
        .padding()
    }

    // Results Table View
    private var resultTableView: some View {
        List(viewModel.meals) { meal in
            Button(action: {
                selectedMeal = meal
                navigateToDetail = true
            }) {
                MealRowView(meal: meal)
                    .padding(.horizontal)
                    .padding(.vertical, 5)
            }
            .buttonStyle(CustomButtonStyle(
                normalColor: Color(.systemBackground),
                pressedColor: Color.gray.opacity(0.2)))
            .listRowInsets(EdgeInsets())
        }
        .listStyle(.plain)
    }
}
