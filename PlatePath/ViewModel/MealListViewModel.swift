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
                DispatchQueue.main.async {
                    self.meals = fetchedMeals.sorted { $0.name < $1.name }
                    self.isLoading = false
                }
            } catch {
                DispatchQueue.main.async {
                    print(error)
                    self.errorMessage = "Failed to load meals: \(error.localizedDescription)"
                    self.isLoading = false
                }
            }
        }
    }

}
