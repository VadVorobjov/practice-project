//
//  TaskDescriptionInitiationCell.swift
//  ThriveApp
//
//  Created by Vadims Vorobjovs on 29/03/2023.
//

import SwiftUI

struct TaskDescriptionInitiationCell: View {
    var mainAction: () -> Void
    var secondaryAction: () -> Void
        
    init(mainAction: @escaping () -> Void, secondaryAction: @escaping () -> Void) {
        self.mainAction = mainAction
        self.secondaryAction = secondaryAction
    }
    
    var body: some View {
        
        VStack {
            TextEditorView(title: "Description")
            
            HStack {
                
                Button {
                    secondaryAction()
                } label: {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.black)
                        .bold()
                }
                
                Button("Next", action: {
                    mainAction()
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
        TaskDescriptionInitiationCell(mainAction: {}, secondaryAction: {})
        .previewLayout(.sizeThatFits)
    }
}
