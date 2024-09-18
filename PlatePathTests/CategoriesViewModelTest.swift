//
//  CategoryViewModelTest.swift
//  PlatePathTests
//
//  Created by Luis Paniagua on 9/17/24.
//

import XCTest
import Combine
@testable import PlatePath

class CategoriesViewModelTests: XCTestCase {

    var viewModel: CategoriesViewModel!
    var mockCategoryService: MockCategoryService!
    var cancellables: Set<AnyCancellable> = []

    override func setUp() {
        super.setUp()
        mockCategoryService = MockCategoryService()
        viewModel = CategoriesViewModel(categoryService: mockCategoryService)
    }

    override func tearDown() {
        viewModel = nil
        mockCategoryService = nil
        super.tearDown()
    }

    // Test fetching categories from JSON
    func testFetchCategoriesFromJSON() throws {

        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertEqual(viewModel.categories.count, 0)

        let categoriesExpectation = XCTestExpectation(description: "Wait for categories to load")
        let isLoadingExpectation = XCTestExpectation(description: "Wait for isLoading to become false")

        // Subscribe to changes
        viewModel.$categories
            .dropFirst()
            .sink { caregories in
                if caregories.count > 0 {
                    categoriesExpectation.fulfill()
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

        viewModel.fetchCategories()

        wait(for: [categoriesExpectation, isLoadingExpectation], timeout: 2.0)

        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertEqual(viewModel.categories.count, 3)
        XCTAssertEqual(viewModel.categories.first?.name, "Beef")

    }

    // Test handling error during category fetching
    func testFetchCategoriesError() throws {
        mockCategoryService.shouldThrowError = true

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

        viewModel.fetchCategories()

        wait(for: [errorMessageExpectation, isLoadingExpectation], timeout: 5.0)

        XCTAssertFalse(viewModel.isLoading)
        XCTAssertEqual(viewModel.errorMessage, "Failed to load categories: Mock error")
        XCTAssertEqual(viewModel.categories.count, 0)
    }

}

class MockCategoryService: CategoryServiceProtocol {
    var shouldThrowError = false
    var mockCategories: [PlatePath.Category] = []

    func getCategories() async throws -> [PlatePath.Category] {
        if shouldThrowError {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Mock error"])
        } else {
            loadCategories(fromFile: "categories")
            return mockCategories
        }
    }

    func getCategoriesList() async throws -> [PlatePath.Category] {
        throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Should not be called"])
    }

    // Helper to decode JSON data from a file
    func loadCategories(fromFile fileName: String) {
        mockCategories = TestHelper.loadCategories(fromFile: fileName)!
    }
}
