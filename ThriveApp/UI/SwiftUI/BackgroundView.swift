//
//  BackgroundView.swift
//  ThriveApp
//
//  Created by Vadims Vorobjovs on 28/04/2023.
//

import SwiftUI

struct BackgroundView: View {
    
    var body: some View {
        Rectangle()
            .ignoresSafeArea()
            .foregroundColor(Color("Background"))
    }
}
