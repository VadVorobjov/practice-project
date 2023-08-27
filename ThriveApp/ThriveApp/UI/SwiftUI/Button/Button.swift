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

struct CircleButton: Buttonable {
    let radius: CGFloat
    let shadow: Bool
    
    init(label: LocalizedStringKey = "",
         radius: CGFloat = screenSize.width,
         action: @escaping () -> Void = {}) {
        self.radius = radius
        self.label = label
        self.action = action
    }
    
    var label: LocalizedStringKey
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(label)
        }
        .buttonStyle(CircleButtonStyle())
    }
}
