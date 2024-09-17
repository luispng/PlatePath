//
//  MealIngredientsView.swift
//  PlatePath
//
//  Created by Luis Paniagua on 9/16/24.
//

import SwiftUI

struct MealIngredientsView: View {
    let ingredients: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Ingredients")
                .font(.system(.title3, design: .serif))
                .padding(.bottom, 8)
                .underline()
            
            ForEach(ingredients, id: \.self) { ingredientMeasurement in
                HStack {
                    Image(systemName: "square")
                        .font(.system(size: 20))
                        .foregroundColor(.gray)
                    
                    Text(ingredientMeasurement)
                        .font(.system(size: 14))
                        .padding(.leading, 5)
                }
                .padding(.vertical, 0)
                .padding(.horizontal, 10)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
    }
}
