//
//  MealListViewModelTests.swift
//  PlatePathTests
//
//  Created by Luis Paniagua on 9/16/24.
//

import XCTest
import Combine
@testable import PlatePath

class MealListViewModelTests: XCTestCase {

    var cancellables: Set<AnyCancellable> = []

    func testFetchMealsSuccess() throws {
        let mockMealService = MockMealService()
        
        let viewModel = MealListViewModel(mealService: mockMealService)

        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertEqual(viewModel.meals.count, 0)

        let mealsExpectation = XCTestExpectation(description: "Wait for meals to load")
        let isLoadingExpectation = XCTestExpectation(description: "Wait for isLoading to become false")

        // Subscribe to changes
        viewModel.$meals
            .dropFirst()
            .sink { meals in
                if meals.count > 0 {
                    mealsExpectation.fulfill()
                }
            }
            .store(in: &cancellables)

        viewModel.$isLoading
            .dropFirst()
            .sink { isLoading in
                if !isLoading {
                    isLoadingExpectation.fulfill()
                }
            }
            .store(in: &cancellables)

        viewModel.fetchMeals(forCategory: "Dessert")

        wait(for: [mealsExpectation, isLoadingExpectation], timeout: 2.0)

        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertEqual(viewModel.meals.count, 3)
        XCTAssertEqual(viewModel.meals.first?.name, "Apam balik")
    }

    func testFetchMealsFailure() throws {
        let mockMealService = MockMealService()
        mockMealService.shouldThrowError = true

        let viewModel = MealListViewModel(mealService: mockMealService)

        let errorMessageExpectation = XCTestExpectation(description: "Wait for errorMessage to be set")
        let isLoadingExpectation = XCTestExpectation(description: "Wait for isLoading to become false")

        // Subscribe to changes
        viewModel.$errorMessage
            .dropFirst()
            .sink { errorMessage in
                if errorMessage != nil {
                    errorMessageExpectation.fulfill()
                }
            }
            .store(in: &cancellables)

        viewModel.$isLoading
            .dropFirst()
            .sink { isLoading in
                if !isLoading {
                    isLoadingExpectation.fulfill()
                }
            }
            .store(in: &cancellables)

        viewModel.fetchMeals(forCategory: "Dessert")

        wait(for: [errorMessageExpectation, isLoadingExpectation], timeout: 5.0)

        XCTAssertFalse(viewModel.isLoading)
        XCTAssertEqual(viewModel.errorMessage, "Failed to load meals: The operation couldn’t be completed. (NSURLErrorDomain error -1011.)")
        XCTAssertEqual(viewModel.meals.count, 0)
    }
}


class MockMealService: MealServiceProtocol {
    var shouldThrowError = false
    var mealsToReturn: [Meal] = []

    func getMeals(forCategory category: String) async throws -> [Meal] {
        if shouldThrowError {
            throw URLError(.badServerResponse)
        }
        loadMeals(fromFile: "meals")
        return mealsToReturn
    }

    func getMeals(firstLetter letter: String) async throws -> [Meal] {
        return mealsToReturn
    }

    func getMeals(search name: String) async throws -> [Meal] {
        return mealsToReturn
    }

    func getMealDetail(mealID: String) async throws -> Meal {
        if shouldThrowError {
            throw MealServiceError.mealNotFound
        }
        return mealsToReturn.first!
    }

    // Helper to decode JSON data from a file
    func loadMeals(fromFile fileName: String) {
        mealsToReturn = TestHelper.loadMeals(fromFile: fileName)!
    }

}
