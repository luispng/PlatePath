//
//  MealTagsView.swift
//  PlatePath
//
//  Created by Luis Paniagua on 9/16/24.
//

import SwiftUI

struct MealTagsSectionView: View {
    let tags: [String]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(tags, id: \.self) { tag in
                    Text(tag)
                        .font(.system(size: 12))
                        .fontWeight(.semibold)
                        .foregroundColor(Color(.secondaryLabel))
                        .padding(.vertical, 8)
                        .padding(.horizontal, 12)
                        .background(Color(.secondarySystemFill))
                        .cornerRadius(15)
                }
            }
            .padding(.horizontal)
        }
    }
}
