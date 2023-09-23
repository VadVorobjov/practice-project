//
//  ViewModifiers.swift
//  ThriveApp
//
//  Created by Vadims Vorobjovs on 30/07/2023.
//

import SwiftUI

struct Elevation: ViewModifier {
    let color: Color
    let radius: CGFloat
    
    init(color: Color = .Elevation.primary, radius: CGFloat = 25) {
        self.color = color
        self.radius = radius
    }
    
    func body(content: Content) -> some View {
        content
            .background(color)
            .cornerRadius(radius)
            .shadow(color: .Shadow.black80, radius: 2, x: 1, y: 1)
    }
}
