//
//  MealDetailView.swift
//  PlatePath
//
//  Created by Luis Paniagua on 9/14/24.
//

import SwiftUI
import UIKit

struct MealDetailView: View {
    let mealID: String
    @StateObject private var viewModel = MealDetailViewModel()
    @State private var hasLoaded: Bool = false

    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView("Loading details...")
                    .padding()
            } else if let mealDetail = viewModel.mealDetail {
                ScrollView {
                    VStack(spacing: 20) {
                        // Header Section
                        MealDetailHeaderView(mealDetail: mealDetail)
                        
                        // Category Section
                        if let categoryName = mealDetail.category, !categoryName.isEmpty {
                            MealCategoryView(categoryName: categoryName)
                        }
                        
                        // Tags Section
                        if let tags = mealDetail.tags, !tags.isEmpty {
                            MealTagsView(tags: tags)
                        }
                        
                        Divider().padding(.horizontal)
                        
                        // Ingredients Section
                        MealIngredientsView(ingredients: mealDetail.ingredientMeasurements)
                        
                        Divider().padding(.horizontal)
                        
                        // Instructions Section
                        MealInstructionsView(instructions: mealDetail.instructions)
                        
                        Divider().padding(.horizontal)
                        
                        // YouTube Video Section
                        if let strYoutube = mealDetail.youtubeURL, 
                            let youtubeURL = URL(string: strYoutube) {
                            MealYouTubeView(youtubeURL: youtubeURL)
                        }
                    }
                    .padding(.bottom, 20)
                }
            } else {
                Text("Meal details not available.")
                    .font(.title2)
                    .foregroundColor(.secondary)
                    .padding()
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if !hasLoaded {
                viewModel.fetchMealDetails(mealID: mealID)
                hasLoaded = true // Mark as loaded
            }
        }
    }
}

// MARK: - MealCategoryView
struct MealCategoryView: View {
    let categoryName: String
    
    var body: some View {
        Text("Category: \(categoryName)")
            .font(.callout)
            .fontWeight(.bold)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 20)
    }
}

// MARK: - MealInstructionsView
struct MealInstructionsView: View {
    let instructions: String?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Instructions")
                .font(.system(.title3, design: .serif))
                .underline()
                .padding(.bottom, 8)
            
            Text(instructions ?? "No instructions available.")
                .font(.system(size: 14))
                .lineSpacing(6)
                .padding(.horizontal, 10)
        }
        .padding(.horizontal, 20)
    }
}

// MARK: - MealYouTubeView
struct MealYouTubeView: View {
    let youtubeURL: URL
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Watch Video")
                .font(.headline)
                .padding(.bottom, 5)
            
            Link(destination: youtubeURL) {
                HStack {
                    Image(systemName: "play.circle.fill")
                        .font(.title)
                    Text("Watch on YouTube")
                        .font(.body)
                }
                .foregroundColor(.blue)
            }
            .padding(.horizontal, 10)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
    }
}

#Preview {
    MealDetailView(mealID: "52893")
}
