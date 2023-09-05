//
//  Button.swift
//  ThriveApp
//
//  Created by Vadims Vorobjovs on 24/03/2023.
//

import SwiftUI

protocol Buttonable: View {
    var label: LocalizedStringKey { get set }
    var action: () -> Void { get set }
}

struct CircleTitleButton {
    
}

struct CircleButton<S: ShapeStyle>: Buttonable {
    let radius: CGFloat
    let shadow: Bool
    let backgroundColor: S
    
    init(radius: CGFloat = screenSize.width,
         shadow: Bool = true,
         backgroundColor: S = Color(hex: 0x3D3B37),
         label: LocalizedStringKey = "",
         action: @escaping () -> Void = {}) {
        self.radius = radius
        self.shadow = shadow
        self.backgroundColor = backgroundColor
        self.label = label
        self.action = action
    }
    
    var label: LocalizedStringKey
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(label)
        }
        .buttonStyle(CircleButtonStyle(radius: radius,
                                       shadow: shadow,
                                       backgroundColor: backgroundColor))
    }
}
