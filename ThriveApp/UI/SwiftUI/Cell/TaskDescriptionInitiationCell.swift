//
//  TaskDescriptionInitiationCell.swift
//  ThriveApp
//
//  Created by Vadims Vorobjovs on 29/03/2023.
//

import SwiftUI

struct TaskDescriptionInitiationCell: View {
    var body: some View {
        TextEditorView(title: "Description", buttonTitle: "Next",
                       buttonAction: {
            print("Description button pressed")
        })
            .padding()
    }
}

struct TaskDescriptionInitiationCell_Previews: PreviewProvider {
    static var previews: some View {
        TextEditorView(title: "Description",
                       buttonTitle: "Next",
                       buttonAction: {
            print("Description button pressed")
        })
        .previewLayout(.sizeThatFits)
    }
}
