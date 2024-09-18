//
//  MealDetailHeaderView.swift
//  PlatePath
//
//  Created by Luis Paniagua on 9/16/24.
//

import SwiftUI

struct MealDetailHeaderView: View {
    let mealDetail: Meal
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            AsyncImage(url: URL(string: mealDetail.imageURL ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 280)
                    .clipped()
            } placeholder: {
                ProgressView()
                    .frame(height: 280)
            }
            
            VStack(alignment: .leading) {
                Text(mealDetail.name)
                    .font(.system(.title, design: .serif))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.bottom, 1)
                    .shadow(radius: 5)
                
                HStack(spacing: 20) {
                    if let area = mealDetail.area, !area.isEmpty {
                        HStack {
                            Image(systemName: "fork.knife")
                            Text(area)
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                    }
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color.black.opacity(0.6), Color.clear]),
                    startPoint: .bottom,
                    endPoint: .top
                )
            )
        }
    }
}
