//
//  Text.swift
//  ThriveApp
//
//  Created by Vadims Vorobjovs on 29/03/2023.
//

import SwiftUI

struct TitleTextView: View {
    let title: String
    let font: Font
    let fontWeight: Font.Weight

    init(title: String, font: Font = .title3, fontWeight: Font.Weight = .bold) {
        self.title = title
        self.font = font
        self.fontWeight = fontWeight
    }
    
    var body: some View {
        Text(title)
            .font(font)
            .fontWeight(fontWeight)
    }
}

struct TitleTextView_Previews: PreviewProvider {
    static var previews: some View {
        TitleTextView(title: "Some Title")
            .previewLayout(.sizeThatFits)
    }
}
