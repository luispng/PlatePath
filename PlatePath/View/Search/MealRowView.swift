//
//  MealRowView.swift
//  PlatePath
//
//  Created by Luis Paniagua on 9/17/24.
//

import SwiftUI

struct MealRowView: View {
    let meal: Meal

    var body: some View {
        HStack {
            AsyncImage(url: URL(string: meal.imageURL!)) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .cornerRadius(8)
            } placeholder: {
                ProgressView()
                    .frame(width: 80, height: 80)
            }

            VStack(alignment: .leading, spacing: 5) {
                Text(meal.name)
                    .font(.headline)
                    .lineLimit(1)
                Text(meal.category ?? "")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .lineLimit(1)
            }
            .padding(.leading, 8)
        }
    }
}
