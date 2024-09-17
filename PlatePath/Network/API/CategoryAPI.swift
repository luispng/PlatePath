//
//  CategoryAPI.swift
//  PlatePath
//
//  Created by Luis Paniagua on 9/16/24.
//

import Foundation

enum CategoryAPI {
    case categories // detail response
    case categoriesList
}

extension CategoryAPI: Endpoint {
    var path: String {
        switch self {
        case .categories:
            return "/categories.php"
        case .categoriesList:
            return "/list.php?c=list"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .categories:
            return .get
        case .categoriesList:
            return .get
        }
    }

    var parameters: [String: Any]? {
        switch self {
        case .categories:
            return nil
        case .categoriesList:
            return ["c": "list"]
        }
    }
}

struct CategoriesResponse: Decodable {
    let categories: [Category]
}

struct CategoriesListResponse: Decodable {
    let meals: [Category]
}
