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
                DispatchQueue.main.async {
                    self.mealDetail = meal
                    self.isLoading = false
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to load meal details: \(error.localizedDescription)"
                    self.isLoading = false
                }
            }
        }
    }
}
