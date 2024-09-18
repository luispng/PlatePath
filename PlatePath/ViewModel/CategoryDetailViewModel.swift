//
//  CategoryDetailViewModel.swift
//  PlatePath
//
//  Created by Luis Paniagua on 9/14/24.
//

import SwiftUI

class CategoryDetailViewModel: ObservableObject {
    @Published var category: Category? = nil
    @Published var meals: [Meal] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil

    private let mealService: MealServiceProtocol

    init(mealService: MealServiceProtocol = MealService()) {
        self.mealService = mealService
    }

    // Fetch meals for this category
    func fetchMeals() {
        self.isLoading = true
        self.errorMessage = nil

        Task {
            do {
                guard let categoryName = category?.name else {
                    await updateUIWithError("Invalid category")
                    return
                }

                // Fetch meals for the selected category
                let fetchedMeals = try await mealService.getMeals(forCategory: categoryName)
                await updateUIWithResults(fetchedMeals)
            } catch {
                await updateUIWithError("Failed to load meals: \(error.localizedDescription)")
            }
        }
    }

    @MainActor
    private func updateUIWithResults(_ fetchedMeals: [Meal]) {
        self.meals = fetchedMeals
        self.isLoading = false
        self.errorMessage = nil
    }

    @MainActor
    private func updateUIWithError(_ errorMessage: String) {
        self.errorMessage = errorMessage
        self.isLoading = false
    }
}
