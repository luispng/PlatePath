//
//  MealCardView.swift
//  PlatePath
//
//  Created by Luis Paniagua on 9/16/24.
//

import SwiftUI

struct MealGridCardView: View {
    let meal: Meal
    
    var body: some View {
        VStack {
            if let imageUrlString = meal.imageURL, let imageUrl = URL(string: imageUrlString) {
                AsyncImage(url: imageUrl) { image in
                    image
                        .resizable()
                        .aspectRatio(1, contentMode: .fit)
                        .clipped()
                } placeholder: {
                    RoundedRectangle(cornerRadius: 0)
                        .fill(Color(.lightGray) .opacity(0.1))
                        .aspectRatio(1, contentMode: .fill)
                        .overlay(ProgressView()
                            .aspectRatio(1, contentMode: .fill)
                        )
                }
                .clipShape(RoundedRectangle(cornerRadius: 12))
            } else {
                RoundedRectangle(cornerRadius: 0)
                    .fill(Color.gray.opacity(0.1))
                    .aspectRatio(1, contentMode: .fill) // 1:1 aspect ratio for placeholder
                    .overlay(Text("No Image").foregroundColor(.gray))
            }
            
            Text(meal.name)
                .font(.subheadline)
                .fontWeight(.bold)
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
        }
        .frame(minHeight: 200) // Constrain the height to ensure consistency in the grid
        .padding(10)
    }
}
