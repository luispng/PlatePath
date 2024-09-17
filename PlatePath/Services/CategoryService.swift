//
//  CategoryService.swift
//  PlatePath
//
//  Created by Luis Paniagua on 9/14/24.
//

import Foundation

protocol CategoryServiceProtocol {
    ///  List all meal categories, detailed response
    func getCategories() async throws -> [Category]
    ///  List all categories, (names only)
    func getCategoriesList() async throws -> [Category]
}

class CategoryService: CategoryServiceProtocol {
    private let networkProvider: NetworkProvider<CategoryAPI>

    init() {
        self.networkProvider = NetworkProvider()
    }

    func getCategories() async throws -> [Category] {
        let response: CategoriesResponse = try await networkProvider.request(.categories)
        return response.categories
    }

    func getCategoriesList() async throws -> [Category] {
        let response: CategoriesListResponse = try await networkProvider.request(.categoriesList)
        return response.meals
    }
}
