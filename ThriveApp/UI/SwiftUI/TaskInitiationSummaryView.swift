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
            
            VStack {
                VStack(alignment: .center) {
                    Text("Task name").bold()
                    Text(task.name)
                    Text("Task Description").bold()
                    Text(task.description)
                        .lineLimit(3)
                }
                .frame(maxHeight: .infinity)
                .padding(.horizontal, 25.0)
                
                InitiationButtonSwiftUI(label: "Initiate") {
                    initiated(task)
                }
                .frame(maxHeight: .infinity)
                
                Spacer()
                    .frame(maxHeight: .infinity)
            }
            .fixedSize(horizontal: true, vertical: false)
            .padding()
        }
    }
}

struct TaskInitiationSummaryView_Previews: PreviewProvider {
    static private var task = Task(name: "Road to greatnes", description: "Fulfill your path with goals & levels")
    static var previews: some View {
        TaskInitiationSummaryView(task: task, initiated: {_ in })
    }
}
