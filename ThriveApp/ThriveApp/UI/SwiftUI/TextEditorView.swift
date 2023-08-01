//
//  TextEditorView.swift
//  ThriveApp
//
//  Created by Vadims Vorobjovs on 29/03/2023.
//

import SwiftUI

struct TextEditorView: View {
    @Binding var text: String
    
    let title: String

    var body: some View {
        VStack(alignment: .center) {
            
            VStack() {
                TextEditor(text: $text)
                    .padding()
                    .textFieldStyle(.roundedBorder)
                    .frame(maxHeight: screenSize.width)
                    .scrollContentBackground(.hidden)
                    .background(Color(.white))
                    .cornerRadius(15)
                    .placeholder(when: text.isEmpty, alignment: .center) {
                        Text("Something to describe")
                            .bold()
                    }
            }
        }
    }
}

struct TextEditorView_Previews: PreviewProvider {
    @State static private var text = ""
    
    static var previews: some View {
        TextEditorView(text: $text, title: "Description")
    }
}
