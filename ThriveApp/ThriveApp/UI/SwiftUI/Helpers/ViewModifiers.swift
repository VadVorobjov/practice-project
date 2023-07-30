//
//  ViewModifiers.swift
//  ThriveApp
//
//  Created by Vadims Vorobjovs on 30/07/2023.
//

import SwiftUI

struct Elevation: ViewModifier {
    let color: Color
    
    func body(content: Content) -> some View {
        content
            .background(color)
            .cornerRadius(25)
            .shadow(color: .black, radius: 2, x: 1, y: 1)
    }
}
