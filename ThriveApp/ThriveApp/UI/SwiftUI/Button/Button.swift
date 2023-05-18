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

struct InitiationButtonSwiftUI: Buttonable {
    
    init(label: LocalizedStringKey = "", action: @escaping () -> Void = {}) {
        self.label = label
        self.action = action
    }
    
    var label: LocalizedStringKey
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(label)
        }
        .buttonStyle(BigRoundButtonStyle())
    }
}
