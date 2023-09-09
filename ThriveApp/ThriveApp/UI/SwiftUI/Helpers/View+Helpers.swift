//
//  View+Helpers.swift
//  ThriveApp
//
//  Created by Vadims Vorobjovs on 28/04/2023.
//

import SwiftUI

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
            ZStack(alignment: alignment) {
                self
                placeholder().opacity(shouldShow ? 1 : 0)
            }
        }
    
    @ViewBuilder func customBackgroundView() -> some View {
        Rectangle()
            .ignoresSafeArea()
            .foregroundColor(.Background.primary)
    }
    
    @ViewBuilder func applyRoundedOverlay() -> some View {
        self
        .background(Color.Background.primary)
        .cornerRadius(25)
        .shadow(color: Color(hex: 0x000000, alpha: 0.5), radius: 4, x: 0, y: 2)
        .overlay(
            RoundedRectangle(cornerRadius: 25)
                .stroke()
                .foregroundColor(Color(hex: 0x000000, alpha: 0.5))
        )
        .padding()
    }
}
