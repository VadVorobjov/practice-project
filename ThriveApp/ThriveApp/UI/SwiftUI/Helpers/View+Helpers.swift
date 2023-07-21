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
                placeholder().opacity(shouldShow ? 1 : 0)
                self
            }
        }
    
    @ViewBuilder func customBackgroundView() -> some View {
        Rectangle()
            .ignoresSafeArea()
            .foregroundColor(Color("background"))
    }
    
    @ViewBuilder func applyRoundedOverlay() -> some View {
        self
        .background(Color("background_distinguish"))
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
