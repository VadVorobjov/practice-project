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
    
    static var background: Color {
        self.init("Background")
    }
    
    static var mainButtonLabel: Color {
        self.init(hex: 0xD1D1D1)
    }
    
    static var mainButtonBackground: Color {
        self.init(hex: 0x3D3B37)
    }
}

extension Color {
    struct Background {
        struct Elevation {
            static let primary = Color("background-elevation-primary")
        }
    }
}
