//
//  CategoryHeaderView.swift
//  PlatePath
//
//  Created by Luis Paniagua on 9/16/24.
//

import SwiftUI

struct CategoryHeaderView: View {
    let category: Category

    var body: some View {
        VStack(spacing: 15) {
            if let imageUrl = URL(string: category.thumbnail) {
                AsyncImage(url: imageUrl) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 150) // Banner height
                        .cornerRadius(3)
                        .clipped()
                } placeholder: {
                    ProgressView()
                        .frame(height: 150)
                }
            } else {
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 150)
                    .overlay(Text("No Image").foregroundColor(.gray))
            }
            Text(category.description)
                .font(.footnote)
                .foregroundColor(.secondary)
                .padding([.leading, .trailing], 20)
                .multilineTextAlignment(.center)
                .lineLimit(4)
        }
        .padding(.bottom, 20)
    }
}
