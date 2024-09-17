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
                    DispatchQueue.main.async {
                        self.errorMessage = "Invalid category."
                    }
                    return
                }

                // Fetch meals for the selected category
                let fetchedMeals = try await mealService.getMeals(forCategory: categoryName)

                DispatchQueue.main.async {
                    self.meals = fetchedMeals.sorted { $0.name < $1.name }
                    self.isLoading = false
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to load meals: \(error.localizedDescription)"
                    self.isLoading = false
                }
            }
        }
    }
}
