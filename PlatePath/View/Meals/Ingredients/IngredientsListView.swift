//
//  IngredientsListView.swift
//  PlatePath
//
//  Created by Luis Paniagua on 9/17/24.
//

import SwiftUI

struct IngredientsListView: View {
    let ingredients: [Ingredient]

    @State private var selectedIngredient: Ingredient?

    var body: some View {
        List(ingredients) { ingredient in
            Button(action: {
                selectedIngredient = ingredient
            }) {
                HStack {
                    AsyncImage(url: URL(string: ingredient.imageSmallURL)) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                    } placeholder: {
                        ProgressView()
                            .frame(width: 50, height: 50)
                    }
                    .cornerRadius(8)

                    VStack(alignment: .leading) {
                        Text(ingredient.name)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        Text(ingredient.measurement ?? "")
                            .font(.subheadline)
                    }

                }
                .padding(.vertical, 10)
                .padding(.horizontal, 15)
            }
            .buttonStyle(CustomButtonStyle(
                normalColor: Color(.systemBackground),
                pressedColor: Color.gray.opacity(0.2))
            )
            .listRowInsets(EdgeInsets()) // Remove default insets for better row style appearance
        }
        .listStyle(.plain)
        .navigationTitle("Ingredients")
        .sheet(item: $selectedIngredient) { ingredient in
            IngredientPreviewView(ingredient: ingredient)
        }
    }
}

#Preview {
    let ingredients = [
        Ingredient(name: "Chicken Breasts", measurement: "2"),
        Ingredient(name: "Cabagge", measurement: "1/2"),
        Ingredient(name: "Cheese", measurement: "250g")
    ]
    return IngredientsListView(ingredients: ingredients)
}
