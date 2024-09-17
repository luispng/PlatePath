//
//  CategoryCardView.swift
//  PlatePath
//
//  Created by Luis Paniagua on 9/16/24.
//

import SwiftUI

struct CategoryCardView: View {
    let category: Category
    
    var body: some View {
        VStack {
            if let imageUrl = URL(string: category.thumbnail) {
                AsyncImage(url: imageUrl) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 200, maxHeight: 150)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                } placeholder: {
                    ProgressView()
                        .frame(maxWidth: 150, maxHeight: 150)
                }
            } else {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.3))
                    .frame(maxWidth: 150, maxHeight: 150)
                    .overlay(Text("No Image").foregroundColor(.gray))
            }
            
            Text(category.name)
                .font(.headline)
                .lineLimit(2)
                .multilineTextAlignment(.center)
        }
        .frame(minHeight: 110)
    }
}
