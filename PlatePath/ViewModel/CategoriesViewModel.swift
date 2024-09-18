//
//  CategoriesViewModel.swift
//  PlatePath
//
//  Created by Luis Paniagua on 9/14/24.
//

import SwiftUI

class CategoriesViewModel: ObservableObject {
    @Published var categories: [Category] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil

    private let categoryService: CategoryServiceProtocol

    init(categoryService: CategoryServiceProtocol = CategoryService()) {
        self.categoryService = categoryService
    }

    // Fetch all category
    func fetchCategories() {
        self.isLoading = true
        self.errorMessage = nil

        Task {
            do {
                let fetchedCategories = try await categoryService.getCategories()
                await updateUIWithResults(fetchedCategories)
            } catch {
                await updateUIWithError("Failed to load categories: \(error.localizedDescription)")
            }
        }
    }

    @MainActor
    private func updateUIWithResults(_ categories: [Category]) {
        self.categories = categories
        self.isLoading = false
        self.errorMessage = nil
    }

    @MainActor
    private func updateUIWithError(_ errorMessage: String) {
        self.errorMessage = errorMessage
        self.isLoading = false
    }
}
