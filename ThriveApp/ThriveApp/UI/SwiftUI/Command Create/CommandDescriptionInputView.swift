//
//  TaskDescriptionInitiationCell.swift
//  ThriveApp
//
//  Created by Vadims Vorobjovs on 29/03/2023.
//

import SwiftUI

struct CommandDescriptionInputView: View {
    @Binding var description: String

    let onReverse: () -> Void
    let onComplete: () -> Void
    
    var body: some View {
        ZStack {
            VStack(alignment: .center, spacing: 0) {
                TitleTextView(title: "Description")
                
                TextEditorView(text: $description, title: "Description")
                    .padding(.top, 20)
                
                HStack(alignment: .center) {
                    Button {
                        onReverse()
                    } label: {
                        Image(systemName: "arrow.left")
                            .foregroundColor(.black)
                            .font(Font.system(size: 26, weight: .bold))
                    }
                    
                    Button("Next", action: {
                        onComplete()
                    })
                    .buttonStyle(MainButtonStyle())
                    .padding(.leading, 25)
                }
                .padding(.top, 25)
                
            }
            .padding(EdgeInsets(top: 20, leading: 20, bottom: 30, trailing: 20))
            .modifier(Elevation(color: .Elevation.primary))
        }
        .padding()
    }
}

struct TaskDescriptionInitiationView_Previews: PreviewProvider {
    static var previews: some View {
        CommandDescriptionInputView(description: .constant("Preview description"), onReverse: {}, onComplete: {})
        .previewLayout(.sizeThatFits)
    }
}
