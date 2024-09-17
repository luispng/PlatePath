//
//  Meal.swift
//  PlatePath
//
//  Created by Luis Paniagua on 9/14/24.
//

import Foundation

struct Meal: Decodable {

    let id: String
    let name: String
    let category: String?
    let area: String?
    let instructions: String?
    let imageURL: String?
    let tags: [String]?
    let youtubeURL: String?
    let source: String?

    let ingredients: [String]
    let measurements: [String]

    // Combine ingredient and ilter out empty pairs
    var ingredientMeasurements: [String] {
        return zip(ingredients, measurements)
            .filter { !$0.0.isEmpty && !$0.1.isEmpty }
            .map { "\($0.1) \($0.0)" }
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)

        id = try container.decode(String.self, forKey: StringCodingKey(stringValue: "idMeal"))
        name = try container.decode(String.self, forKey: StringCodingKey(stringValue: "strMeal"))
        category = try? container.decode(String.self, forKey: StringCodingKey(stringValue: "strCategory"))
        area = try? container.decode(String.self, forKey: StringCodingKey(stringValue: "strArea"))
        instructions = try? container.decode(String.self, forKey: StringCodingKey(stringValue: "strInstructions"))
        imageURL = try? container.decode(String.self, forKey: StringCodingKey(stringValue: "strMealThumb"))
        tags = try? container.decode(String.self, forKey: StringCodingKey(stringValue: "strTags")).components(separatedBy: ",")
        youtubeURL = try? container.decode(String.self, forKey: StringCodingKey(stringValue: "strYoutube"))
        source = try? container.decode(String.self, forKey: StringCodingKey(stringValue: "strSource"))

        // ingredients and measurements
        ingredients = (1...20).compactMap { index in
            let key = StringCodingKey(stringValue: "strIngredient\(index)")
            return try? container.decodeIfPresent(String.self, forKey: key)
        }.filter { !$0.isEmpty }

        measurements = (1...20).compactMap { index in
            let key = StringCodingKey(stringValue: "strMeasure\(index)")
            return try? container.decodeIfPresent(String.self, forKey: key)
        }.filter { !$0.isEmpty }
    }

    struct StringCodingKey: CodingKey {
        var stringValue: String
        var intValue: Int? { return nil }

        init(stringValue: String) {
            self.stringValue = stringValue
        }

        init?(intValue: Int) {
            return nil
        }
    }
}
