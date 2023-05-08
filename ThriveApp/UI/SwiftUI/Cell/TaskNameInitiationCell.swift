//
//  TaskNameInitiationCell.swift
//  ThriveApp
//
//  Created by Vadims Vorobjovs on 21/03/2023.
//

import SwiftUI

struct TaskNameInitiationCell: View {
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
        }
    }
}

struct TaskNameInitiationCell_Previews: PreviewProvider {
    @State static private var name = ""
    static var previews: some View {
        TaskNameInitiationCell(completion: { _ in })
            .previewLayout(.sizeThatFits)
    }
}
