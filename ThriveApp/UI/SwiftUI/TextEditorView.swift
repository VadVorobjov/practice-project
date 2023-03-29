//
//  TextEditorView.swift
//  ThriveApp
//
//  Created by Vadims Vorobjovs on 29/03/2023.
//

import SwiftUI

struct TextEditorView: View {
    @State private var text: String = ""
    
    let title: String
    let buttonTitle: String
    let buttonAction: () -> Void

    var body: some View {
        VStack(alignment: .center) {
            TitleTextView(title: "Description")
            
            VStack() {
                TextEditor(text: $text)
                    .frame(height: screenSize.width / 2.5)
            }.overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.black)
            ).padding([.leading, .bottom, .trailing])
            
            Button(buttonTitle) {
                buttonAction()
            }
            .buttonStyle(MainButtonStyle())
        }
        .padding()
    }
}

struct TextEditorView_Previews: PreviewProvider {
    static var previews: some View {
        TextEditorView(title: "Description",
                       buttonTitle: "Go next") {
            print("Button pressed")
        }
    }
}
