//
//  TaskNameInitiationName.swift
//  ThriveApp
//
//  Created by Vadims Vorobjovs on 21/03/2023.
//

import SwiftUI

struct TaskNameInitiationView: View {
    @State private var name: String = ""
    
    var completion: (String) -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .center) {
                TitleTextView(title: "Name")

                TextFieldView(
                    text: $name,
                    title: "Name",
                    placeholderText: "Name your task",
                    buttonTitle: "Next"
                )
                
                Button("Next") {
                    completion(name)
                }
                .buttonStyle(MainButtonStyle())
                .padding(.top)
            }
            .padding()
            .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke()
                .shadow(color: .gray, radius: 4, x: 0, y: 2)
            )
            .padding()
        }
    }
}

struct TaskNameInitiationCell_Previews: PreviewProvider {
    @State static private var name = ""
    static var previews: some View {
        TaskNameInitiationView(completion: { _ in })
            .previewLayout(.sizeThatFits)
    }
}
