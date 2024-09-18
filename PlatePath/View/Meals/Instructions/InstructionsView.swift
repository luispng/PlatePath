//
//  Instructions.swift
//  PlatePath
//
//  Created by Luis Paniagua on 9/17/24.
//

import SwiftUI

struct InstructionsView: View {
    let instructions: String

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                Text("Instructions")
                    .font(.system(.title2, design: .serif))
                    .underline()
                    .padding()

                Text(instructions)
                    .font(.system(size: 15))
                    .lineSpacing(6)
                    .padding()

                Spacer()
            }
            .padding()
        }
    }
}
