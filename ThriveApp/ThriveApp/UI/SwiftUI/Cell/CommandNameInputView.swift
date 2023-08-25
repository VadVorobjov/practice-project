//
//  CommandNameInputView.swift
//  ThriveApp
//
//  Created by Vadims Vorobjovs on 21/03/2023.
//

import SwiftUI

struct CommandNameInputView: View {
    @Binding var name: String
    let onComplete: () -> Void
        
    var body: some View {
        ZStack {
            VStack(alignment: .center, spacing: 0.0) {
                TitleTextView(title: "Name")
                
                TextFieldView(
                    text: $name,
                    title: "Name",
                    placeholderText: "Name your task",
                    buttonTitle: "Next"
                )
                .padding(.top, 20)
                
                Button("Next") {
                    onComplete()
                }
                .buttonStyle(MainButtonStyle())
                .padding(.top, 25)
            }
            .padding(EdgeInsets(top: 24, leading: 24, bottom: 30, trailing: 24))
            .modifier(Elevation(color: .Elevation.primary))
        }
        .padding()
    }
}

struct TaskNameInitiationCell_Previews: PreviewProvider {
    @State static private var name = ""
    static var previews: some View {
        CommandNameInputView(name: $name, onComplete: { })
            .previewLayout(.sizeThatFits)
    }
}
