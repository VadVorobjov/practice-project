//
//  Button+Helpers.swift
//  ThriveApp
//
//  Created by Vadims Vorobjovs on 24/03/2023.
//

import SwiftUI

struct CircleButtonStyle<S: ShapeStyle>: ButtonStyle {
    let radius: CGFloat
    let shadow: Bool
    let backgroundColor: S
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label.foregroundColor(Color(hex: 0xD1D1D1))
            .font(Font.system(.title2, weight: .bold))
            .frame(width: radius / 2, height: radius / 2)
            .background(backgroundColor)
            .clipShape(Circle())
            .shadow(color: shadow ? Color(hex: 0xDE3D3D) : .black.opacity(0), radius: 5.0)
            .scaleEffect(configuration.isPressed ? 0.99 : 1)
    }
}

struct MainButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            Spacer()
            configuration.label.foregroundColor(.mainButtonLabel)
                .font(.system(size: 20, weight: .bold))
            Spacer()
        }
        .frame(width: 195, height: 48)
        .background(Color.Button.backgroundPrimary)
        .cornerRadius(10)
        .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}
