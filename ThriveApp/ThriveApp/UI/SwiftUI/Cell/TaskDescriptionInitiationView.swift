//
//  TaskDescriptionInitiationCell.swift
//  ThriveApp
//
//  Created by Vadims Vorobjovs on 29/03/2023.
//

import SwiftUI

struct TaskDescriptionInitiationView: View {
    @State private var description: String = ""

    private let backAction: () -> Void
    private let completion: (String) -> Void
            
    init(backAction: @escaping () -> Void, completion: @escaping (String) -> Void) {
        self.backAction = backAction
        self.completion = completion
    }
    
    var body: some View {
        ZStack {
            VStack(alignment: .center, spacing: 0) {
                TitleTextView(title: "Description")
                
                TextEditorView(text: $description, title: "Description")
                    .padding(.top, 20)
                
                HStack(alignment: .center) {
                    Button {
                        backAction()
                    } label: {
                        Image(systemName: "arrow.left")
                            .foregroundColor(.black)
                            .font(Font.system(size: 26, weight: .bold))
                    }
                    
                    Button("Next", action: {
                        completion(description)
                    })
                    .buttonStyle(MainButtonStyle())
                    .padding(.leading, 25)
                }
                .padding(.top, 25)
                
            }
            .padding(EdgeInsets(top: 20, leading: 20, bottom: 30, trailing: 20))
            .modifier(Elevation(color: .Background.Elevation.primary))
        }
        .padding()
    }
}

struct TaskDescriptionInitiationView_Previews: PreviewProvider {
    static var previews: some View {
        TaskDescriptionInitiationView(backAction: {}, completion: { _ in })
        .previewLayout(.sizeThatFits)
    }
}
