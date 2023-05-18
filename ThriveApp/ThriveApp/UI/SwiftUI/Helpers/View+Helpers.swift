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
}
