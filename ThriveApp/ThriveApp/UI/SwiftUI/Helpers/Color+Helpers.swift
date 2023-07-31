//
//  Color+Helpers.swift
//  ThriveApp
//
//  Created by Vadims Vorobjovs on 16/03/2023.
//

import UIKit
import SwiftUI

extension Color {
    init(hex: UInt, alpha: Double = 1.0) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255.0,
            green: Double((hex >> 08) & 0xff) / 255.0,
            blue: Double((hex >> 00) & 0xff) / 255.0,
            opacity: alpha
        )
    }
    
    static var mainButtonLabel: Color {
        self.init(hex: 0xD1D1D1)
    }
}

extension Color {
    struct Background {
        static let primary = Color("Background")
        
        struct Elevation {
            static let primary = Color("background-elevation-primary")
        }
    }
    
    struct Button {
        static let primary = Color("button-primary")
    }
}
