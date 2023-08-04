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

    @State private var expandDescription = false

    var body: some View {
        ZStack(alignment: .top) {
            customBackgroundView()

            HStack(alignment: .top) {
                VStack(alignment: .center, spacing: 0) {
                    TitleTextView(title: task.name, font: .system(size: 24), fontWeight: .semibold)
                        .shadow(radius: 1, x: 1, y: 1)
                        .multilineTextAlignment(.center)

                    if !task.description.isEmpty {
                        VStack (alignment: .leading) {
                            Text(task.description)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .font(.system(size: 17))
                                .fontWeight(.medium)
                                .padding(.bottom, 5)
                                .lineLimit(expandDescription ? .max : 3)
                                .contentTransition(.opacity)
                            Button {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    expandDescription.toggle()
                                }
                            } label: {
                                Text(expandDescription ? "Less" : "More")
                                    .multilineTextAlignment(.leading)
                                    .font(.title3)
//                                    .foregroundColor(.black)
                            }

                        }
                        .padding(.top)
                    }

                    ExpandableView(title: "Categories") {
                        Text(task.description)
                    }
                    .padding(.top)
                }
                .padding()
            }
        }
    }
}

struct TaskInitiationSummaryView_Previews: PreviewProvider {
    static private var task = Task(
        name: "Walk da Dog",
        description: "Like its name implies, SwiftUI’s ZStack type is the Z-axis equivalent of the horizontally-oriented HStack and the vertical VStack. When placing multiple views within a ZStack"
    )

    static var previews: some View {
        TaskInitiationSummaryView(task: task, initiated: {_ in })
    }
}
