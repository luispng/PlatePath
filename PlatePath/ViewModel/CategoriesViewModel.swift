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
                DispatchQueue.main.async {
                    self.categories = fetchedCategories
                    self.isLoading = false
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to load categories: \(error.localizedDescription)"
                    self.isLoading = false
                }
            }
        }
    }
}
