//
//  IngredientPreviewView.swift
//  PlatePath
//
//  Created by Luis Paniagua on 9/17/24.
//

import SwiftUI

struct IngredientPreviewView: View {
    let ingredient: Ingredient
    
    var body: some View {
        VStack {
            Spacer()
            
            AsyncImage(url: URL(string: ingredient.imageURL)) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: 300)
            } placeholder: {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: 300)
            }
            .padding(20)
            
            Spacer()
            
            VStack(alignment: .center) {
                Text(ingredient.name)
                    .font(.headline)
                Text(ingredient.measurement ?? "")
                    .font(.subheadline)
            }
            
            Spacer()
        }
        .navigationTitle("Ingredient Image")
        .navigationBarTitleDisplayMode(.inline)
    }
}
