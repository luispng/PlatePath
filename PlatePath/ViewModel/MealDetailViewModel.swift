//
//  MealDetailViewModel.swift
//  PlatePath
//
//  Created by Luis Paniagua on 9/14/24.
//

import SwiftUI

class MealDetailViewModel: ObservableObject {
    @Published var mealDetail: Meal? = nil
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil

    private let mealService: MealServiceProtocol

    init(mealService: MealServiceProtocol = MealService()) {
        self.mealService = mealService
    }

    // Fetch meal details by meal ID
    func fetchMealDetails(mealID: String) {
        self.isLoading = true
        self.errorMessage = nil

        Task {
            do {
                let meal = try await mealService.getMealDetail(mealID: mealID)
                await updateUIWithResults(meal)
            } catch {
                await updateUIWithError("Failed to load meal details: \(error.localizedDescription)")
            }
        }
    }

    @MainActor
    private func updateUIWithResults(_ meal: Meal) {
        self.mealDetail = meal
        self.isLoading = false
        self.errorMessage = nil
    }

    @MainActor
    private func updateUIWithError(_ errorMessage: String) {
        self.errorMessage = errorMessage
        self.isLoading = false
    }

}
