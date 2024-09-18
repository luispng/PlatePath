//
//  Meal.swift
//  PlatePath
//
//  Created by Luis Paniagua on 9/14/24.
//

import Foundation

struct Meal: Decodable, Identifiable, Hashable {

    let id: String
    let name: String
    let category: String?
    let area: String?
    let instructions: String?
    let imageURL: String?
    let tags: [String]?
    let youtubeURL: String?
    let source: String?

    let ingredients: [Ingredient]

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
        let ingredientNames = (1...20).compactMap { index in
            let key = StringCodingKey(stringValue: "strIngredient\(index)")
            return try? container.decodeIfPresent(String.self, forKey: key)
        }.filter { !$0.isEmpty }

        let ingredientMeasurements = (1...20).compactMap { index in
            let key = StringCodingKey(stringValue: "strMeasure\(index)")
            return try? container.decodeIfPresent(String.self, forKey: key)
        }.filter { !$0.isEmpty }

        ingredients = zip(ingredientNames, ingredientMeasurements).map { name, measurement in
            Ingredient(name: name, measurement: measurement)
        }
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

    static func == (lhs: Meal, rhs: Meal) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
