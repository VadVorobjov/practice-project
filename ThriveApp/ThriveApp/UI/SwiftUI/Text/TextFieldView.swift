//
//  TextFieldView.swift
//  ThriveApp
//
//  Created by Vadims Vorobjovs on 05/05/2023.
//

import SwiftUI

struct TextFieldView: View {
    @Binding var text: String
    
    let title: String
    let placeholderText: String
    let buttonTitle: String
    
    var body: some View {
        TextField("", text: $text)
            .frame(height: 44)
            .font(Font.system(size: 12))
            .placeholder(when: text.isEmpty) {
                Text("Name your task").foregroundColor(.black)
                    .font(.footnote)
            }
            .padding(.leading)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke()
            )
    }
}
