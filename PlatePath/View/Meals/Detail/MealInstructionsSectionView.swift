//
//  MealDetailInstructionsView.swift
//  PlatePath
//
//  Created by Luis Paniagua on 9/17/24.
//

import SwiftUI

struct MealInstructionsSectionView: View {
    let instructions: String?
    @State private var isPresented = false

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {

            Button(action: {
                isPresented = true
            }) {
                HStack {
                    Text("Instructions")
                        .font(.system(.title3, design: .serif))
                        .foregroundColor(.primary)
                        .underline()
                        .padding(.bottom, 8)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.system(size: 20))
                        .foregroundColor(.gray)
                }
            }

            Text(instructions ?? "No instructions available.")
                .font(.system(size: 14))
                .lineSpacing(3)
                .padding(.horizontal, 10)
        }
        .padding(.horizontal, 20)
        .sheet(isPresented: $isPresented) {
            if let instructions = instructions {
                InstructionsView(instructions: instructions)
            }
        }
    }
}
