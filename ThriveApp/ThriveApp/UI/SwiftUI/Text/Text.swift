//
//  Text.swift
//  ThriveApp
//
//  Created by Vadims Vorobjovs on 29/03/2023.
//

import SwiftUI

struct TitleTextView: View {
    let title: String
    
    var body: some View {
        Text(title)
            .font(.title3)
            .fontWeight(.bold)
    }
}

struct TitleTextView_Previews: PreviewProvider {
    static var previews: some View {
        TitleTextView(title: "Some title")
    }
}
