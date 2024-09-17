//
//  Category.swift
//  PlatePath
//
//  Created by Luis Paniagua on 9/14/24.
//

import Foundation

struct Category: Decodable, Identifiable {
    let id: String
    let name: String
    let thumbnail: String
    let description: String

    enum CodingKeys: String, CodingKey {
        case id = "idCategory"
        case name = "strCategory"
        case thumbnail = "strCategoryThumb"
        case description = "strCategoryDescription"
    }
}
