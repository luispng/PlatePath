//
//  BrowseView.swift
//  PlatePath
//
//  Created by Luis Paniagua on 9/14/24.
//

import SwiftUI

struct CategoriesView: View {
    @StateObject private var viewModel = CategoriesViewModel()
    @State private var hasLoaded: Bool = false
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isLoading {
                    ProgressView("Loading categories...")
                        .scaleEffect(1.0, anchor: .center)
                        .padding()
                } else if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.headline)
                        .padding()
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 20) {
                            ForEach(viewModel.categories) { category in
                                NavigationLink(destination: CategoryDetailView(category: category)) {
                                    CategoryCardView(category: category)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding([.leading, .trailing], 10)
                        .padding(.top)
                    }
                    .navigationTitle("Categories")
                }
            }
            .onAppear {
                if !hasLoaded {
                    viewModel.fetchCategories()
                    hasLoaded = true // Mark as loaded after the first fetch
                }
            }
        }
    }
}

#Preview {
    CategoriesView()
}
