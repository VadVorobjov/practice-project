//
//  TaskDescriptionInitiationCell.swift
//  ThriveApp
//
//  Created by Vadims Vorobjovs on 29/03/2023.
//

import SwiftUI

struct TaskDescriptionInitiationCell: View {
    @State private var description: String = ""

    private let backAction: () -> Void
    private let completion: (String) -> Void
            
    init(backAction: @escaping () -> Void, completion: @escaping (String) -> Void) {
        self.backAction = backAction
        self.completion = completion
    }
    
    var body: some View {
        
        VStack {
            TextEditorView(text: $description, title: "Description")
            
            HStack {
                
                Button {
                    backAction()
                } label: {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.black)
                        .bold()
                }
                
                Button("Next", action: {
                    completion(description)
                })
                .buttonStyle(MainButtonStyle())
                .padding(.leading)
            }

        }
        .padding()
    }
}

struct TaskDescriptionInitiationCell_Previews: PreviewProvider {
    static var previews: some View {
        TaskDescriptionInitiationCell(backAction: {}, completion: { _ in })
        .previewLayout(.sizeThatFits)
    }
}
