//
//  MealListViewModel.swift
//  PlatePath
//
//  Created by Luis Paniagua on 9/14/24.
//

import SwiftUI

class MealListViewModel: ObservableObject {
    @Published var meals: [Meal] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil

    private let mealService: MealServiceProtocol

    init(mealService: MealServiceProtocol = MealService()) {
        self.mealService = mealService
    }

    // Fetch meals and update the UI state
    func fetchMeals(forCategory category: String) {
        self.isLoading = true
        self.errorMessage = nil

        Task {
            do {
                let fetchedMeals = try await mealService.getMeals(forCategory: category)
                await updateUIWithResults(fetchedMeals)
            } catch {
                await updateUIWithError("Failed to load meals: \(error.localizedDescription)")
            }
        }
    }

    @MainActor
    private func updateUIWithResults(_ fetchedMeals: [Meal]) {
        self.meals = fetchedMeals.sorted { $0.name < $1.name }
        self.isLoading = false
        self.errorMessage = nil
    }

    @MainActor
    private func updateUIWithError(_ errorMessage: String) {
        self.errorMessage = errorMessage
        self.isLoading = false
    }

}
