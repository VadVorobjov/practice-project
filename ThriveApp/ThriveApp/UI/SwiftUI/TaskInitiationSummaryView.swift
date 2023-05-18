//
//  TaskInitiationSummaryView.swift
//  ThriveApp
//
//  Created by Vadims Vorobjovs on 04/04/2023.
//

import SwiftUI

struct TaskInitiationSummaryView: View {
    let task: Task
    let initiated: (Task) -> Void
    
    var body: some View {
        ZStack {
            customBackgroundView()
            
            VStack(alignment: .center) {
                VStack(alignment: .leading) {
                    Text("Name").bold()
                    Text(task.name)
                        .padding(.bottom)
                    
                    Text("Description").bold()
                    Text(task.description)
                        .lineLimit(3)
                }
                
                Button("Initiate") {
                    initiated(task)
                }
                .buttonStyle(MainButtonStyle())
                .padding(.top)
            }
            .padding()
        }
    }
}

struct TaskInitiationSummaryView_Previews: PreviewProvider {
    static private var task = Task(
        name: "Road to greatnes",
        description: "Fulfill your path with goals & levels."
    )

    static var previews: some View {
        TaskInitiationSummaryView(task: task, initiated: {_ in })
    }
}
