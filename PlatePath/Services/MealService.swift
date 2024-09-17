//
//  MealAPI.swift
//  PlatePath
//
//  Created by Luis Paniagua on 9/14/24.
//

import Foundation

protocol MealServiceProtocol {
    /// Filter meals by Category
    func getMeals(forCategory category: String) async throws -> [Meal]
    /// List all meals by first letter
    func getMeals(firstLetter letter: String) async throws -> [Meal]
    /// Search meal by name
    func getMeals(search name: String) async throws -> [Meal]
    /// Full meal details by id
    func getMealDetail(mealID: String) async throws -> Meal
}

class MealService: MealServiceProtocol {
    private let networkProvider: NetworkProvider<MealAPI>

    init() {
        self.networkProvider = NetworkProvider()
    }

    func getMeals(forCategory category: String) async throws -> [Meal] {
        let response: MealListResponse = try await networkProvider.request(.mealsByCategory(category: category))
        return response.meals
    }

    func getMeals(firstLetter letter: String) async throws -> [Meal] {
        let response: MealListResponse = try await networkProvider.request(.mealsByFirstLetter(letter: letter))
        return response.meals
    }

    func getMeals(search name: String) async throws -> [Meal] {
        let response: MealListResponse = try await networkProvider.request(.mealSearch(name: name))
        return response.meals
    }

    func getMealDetail(mealID: String) async throws -> Meal {
        let response: MealDetailResponse = try await networkProvider.request(.mealDetails(mealId: mealID))

        guard let meal = response.meals.first else {
            throw MealServiceError.mealNotFound
        }

        return meal
    }
}

enum MealServiceError: Error, LocalizedError {
    case mealNotFound
    var errorDescription: String? {
        switch self {
        case .mealNotFound:
            return "The requested meal could not be found."
        }
    }
}
