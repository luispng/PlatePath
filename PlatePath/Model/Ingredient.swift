//
//  Ingredient.swift
//  PlatePath
//
//  Created by Luis Paniagua on 9/17/24.
//

import Foundation

struct Ingredient: Identifiable {
    private let ingredientImageBaseURL = "https://www.themealdb.com/images/ingredients/"

    let id = UUID() // use this since API doesn't always return id
    let name: String
    let measurement: String?

    // Generate image URL
    var imageURL: String {
        "\(ingredientImageBaseURL)\(name).png"
    }

    // Generate small image URL
    var imageSmallURL: String {
        "\(ingredientImageBaseURL)\(name)-Small.png"
    }

    // Measurement and name
    var ingredientMeasurement: String {
        if let measurement {
            return "\(measurement) \(name)"
        } else {
            return name
        }
    }
}
