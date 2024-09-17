//
//  MealAPI.swift
//  PlatePath
//
//  Created by Luis Paniagua on 9/16/24.
//

import Foundation

enum MealAPI {
    case mealsByCategory(category: String)
    case mealsByFirstLetter(letter: String)
    case mealSearch(name: String)
    case mealDetails(mealId: String)
}

extension MealAPI: Endpoint {
    var path: String {
        switch self {
        case .mealsByCategory( _):
            return "/filter.php"
        case .mealsByFirstLetter( _):
            return "/search.php"
        case .mealSearch( _):
            return "/search.php"
        case .mealDetails( _):
            return "/lookup.php"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .mealsByCategory( _):
            return .get
        case .mealsByFirstLetter( _):
            return .get
        case .mealSearch( _):
            return .get
        case .mealDetails( _):
            return .get
        }
    }

    var parameters: [String: Any]? {
        switch self {
        case .mealsByCategory(let category):
            return ["c": category]
        case .mealsByFirstLetter(let letter):
            return ["f": letter]
        case .mealSearch(let name):
            return ["s": name]
        case .mealDetails(let mealId):
            return ["i": mealId]
        }
    }
}

struct MealListResponse: Decodable {
    let meals: [Meal]
}

struct MealDetailResponse: Decodable {
    let meals: [Meal]
}
