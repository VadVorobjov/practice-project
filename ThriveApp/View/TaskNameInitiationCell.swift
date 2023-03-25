//
//  TaskNameInitiationCell.swift
//  ThriveApp
//
//  Created by Vadims Vorobjovs on 21/03/2023.
//

import SwiftUI

protocol InitiationDataProtocol {
    var name: String { get }
    var description: String { get }
}

struct InitiationData: InitiationDataProtocol {
    var name: String { "name" }
    var description: String { "description" }
}

struct TaskList: View {

    var body: some View {
        ScrollViewReader { proxy in
            List {
                TaskNameInitiationCell(data: InitiationData())
                TaskNameInitiationCell(data: InitiationData())
                TaskNameInitiationCell(data: InitiationData())
            }
        }
        
    }
}

struct TaskNameInitiationCell: View {
    @State private var text: String = ""
    
    var data: InitiationData
    
    var body: some View {
        Group {
            HStack(alignment: .center) {
                VStack(alignment: .center) {
                    Label("Name", image: "circle.fill")
                        .font(Font.system(.title3).bold())
                    TextField("text", text: $text)
                        .frame(height: 30)
                        .font(Font.system(size: 12))
                        .padding(5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(lineWidth: 1.0)
                        )
                        .padding()
                    Button("Next") {
                        print("tap")
                    }
                    .buttonStyle(MainButtonStyle())
                    .padding()
                }
            }
        }
    }
}

struct TaskNameInitiationCell_Previews: PreviewProvider {
    
    static var previews: some View {
        TaskNameInitiationCell(data: InitiationData())
    }
}
