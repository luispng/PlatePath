//
//  TestHelper.swift
//  PlatePathTests
//
//  Created by Luis Paniagua on 9/17/24.
//

import XCTest
@testable import PlatePath

class TestHelper {

    // Helper get meals from JSON file
    static func loadMeals(fromFile fileName: String) -> [Meal]? {
        guard let jsonData = loadJSON(fromFile: fileName) else {
            print("Failed to load \(fileName).json")
            return nil
        }
        let decoder = JSONDecoder()
        do {
            let response = try decoder.decode(MealListResponse.self, from: jsonData)
            print("Successfully decoded meals: \(response.meals.count)")
            return response.meals
        } catch {
            print("Failed to decode JSON: \(error)")
            return nil
        }
    }

    // Helper get categories from JSON file
    static func loadCategories(fromFile fileName: String) -> [PlatePath.Category]? {
        guard let jsonData = loadJSON(fromFile: fileName) else {
            print("Failed to load \(fileName).json")
            return nil
        }
        let decoder = JSONDecoder()
        do {
            let response = try decoder.decode(CategoriesResponse.self, from: jsonData)
            print("Successfully decoded meals: \(response.categories.count)")
            return response.categories
        } catch {
            print("Failed to decode JSON: \(error)")
            return nil
        }
    }

    // Private helper function to load JSON data from a file
    private static func loadJSON(fromFile fileName: String) -> Data? {
        let bundle = Bundle(for: TestHelper.self)
        if let url = bundle.url(forResource: fileName, withExtension: "json") {
            return try? Data(contentsOf: url)
        }
        print("File not found: \(fileName).json")
        return nil
    }
}
