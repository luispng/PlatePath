//
//  CustomButtonStyle.swift
//  PlatePath
//
//  Created by Luis Paniagua on 9/17/24.
//

import SwiftUI

struct CustomButtonStyle: ButtonStyle {
    var normalColor: Color = .clear
    var pressedColor: Color = Color.gray.opacity(0.2)

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(configuration.isPressed ? pressedColor : normalColor)
            .animation(.easeInOut, value: configuration.isPressed)
    }
}
