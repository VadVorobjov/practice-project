//
//  TaskNameInitiationCell.swift
//  ThriveApp
//
//  Created by Vadims Vorobjovs on 21/03/2023.
//

import SwiftUI

struct TaskNameInitiationCell: View {
    var action: () -> Void
    var completion: (String) -> Void
    
    var body: some View {
        HStack {
            TextFieldView(title: "Name",
                          placeholderText: "Name your task",
                          buttonTitle: "Next",
                          buttonAction: action)
        }.padding()
    }
}

struct TaskNameInitiationCell_Previews: PreviewProvider {
    @State static private var name = ""
    static var previews: some View {
        TaskNameInitiationCell(action: {}, completion: { _ in })
            .previewLayout(.sizeThatFits)
    }
}

struct TextFieldView: View {
    @State var text: String = ""
    
    let title: String
    let placeholderText: String
    let buttonTitle: String
    let buttonAction: () -> Void

    var body: some View {
        VStack(alignment: .center) {
            TitleTextView(title: "Name")
            TextField("", text: $text)
                .frame(height: 35)
                .font(Font.system(size: 12))
                .placeholder(when: text.isEmpty) {
                    Text("Name your task").foregroundColor(.black)
                        .font(.footnote)
                }
                .padding(.leading)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(lineWidth: 1.0)
                )
                .padding(.bottom)
            
            Button(buttonTitle) {
                buttonAction()
            }
            .buttonStyle(MainButtonStyle())
        }
    }
}
