//
//  MealIngredientsView.swift
//  PlatePath
//
//  Created by Luis Paniagua on 9/16/24.
//

import SwiftUI

struct MealIngredientsSectionView: View {
    let ingredients: [Ingredient]
    @State private var selectedIngredient: Ingredient?

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            NavigationLink(destination: IngredientsListView(ingredients: ingredients)) {
                HStack {
                    Text("Ingredients")
                        .font(.system(.title3, design: .serif))
                        .underline()
                        .foregroundColor(.primary)
                        .padding(.bottom, 8)

                    Spacer()

                    // Preview images for the first three ingredients
                    HStack(spacing: 5) {
                        ForEach(ingredients.prefix(3)) { ingredient in
                            AsyncImage(url: URL(string: ingredient.imageSmallURL)) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 20)
                                    .cornerRadius(2)
                            } placeholder: {
                                ProgressView()
                                    .frame(width: 20, height: 20)
                            }
                        }
                    }

                    Image(systemName: "chevron.right")
                        .font(.system(size: 20))
                        .foregroundColor(.gray)
                }
            }

            ForEach(ingredients) { ingredient in
                HStack {
                    Image(systemName: "square")
                        .font(.system(size: 20))
                        .foregroundColor(.gray)
                    Button(action: {
                        selectedIngredient = ingredient
                    }) {

                        HStack(spacing: 0) {
                            Text(ingredient.measurement ?? "")
                                .font(.system(size: 14))
                                .fontWeight(.regular)
                                .foregroundColor(.primary)
                                .padding(.leading, 5)

                            Text(ingredient.name)
                                .font(.system(size: 14))
                                .fontWeight(.semibold)
                                .foregroundColor(.primary)
                                .padding(.leading, 5)
                        }
                    }
                }
                .padding(.vertical, 0)
                .padding(.horizontal, 10)

            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
        .sheet(item: $selectedIngredient) { ingredient in
            IngredientPreviewView(ingredient: ingredient)
        }
    }
}
