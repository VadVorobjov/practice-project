//
//  Button.swift
//  ThriveApp
//
//  Created by Vadims Vorobjovs on 24/03/2023.
//

import SwiftUI

protocol Buttonessa: View {
    var label: LocalizedStringKey { get set }
    var systemImage: String { get set }
    var action: () -> Void { get set }
}

struct InitiationButtonSwiftUI: Buttonessa {
    
    init(label: LocalizedStringKey = "", systemImage: String = "", action: @escaping () -> Void = {}) {
        self.label = label
        self.systemImage = systemImage
        self.action = action
    }
    
    var label: LocalizedStringKey
    var systemImage: String
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(label)
        }
        .buttonStyle(BigRoundButtonStyle())
    }
}
