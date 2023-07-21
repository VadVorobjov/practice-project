//
//  TaskInitiationView.swift
//  ThriveApp
//
//  Created by Vadims Vorobjovs on 25/03/2023.
//

import SwiftUI

struct TaskInitiationView: View {
    @State private var task: Task // TODO: got a feeling, that this should be handled by `presenter` or maybe `viewModel`

    private var navigation: Navigation

    init(navigation: Navigation, task: Task) {
        self.navigation = navigation
        self.task = task
    }
    
    private enum Steps: Hashable {
        case name
        case description
        case final
    }
    
    var body: some View {
        ZStack {
            customBackgroundView()
            
            ScrollView(.horizontal, showsIndicators: false) {
                ScrollViewReader { proxy in
                    HStack(alignment: .center) {
                        
                        HStack {
                            Spacer()
                            TaskNameInitiationView(name: $task.name) {
                                proxy.scrollWithAnimationTo(Steps.description)
                            }
                            Spacer()
                        }
                        .id(Steps.name)
                        .frame(width: screenSize.width)
                        
                        HStack {
                            Spacer()
                            TaskDescriptionInitiationCell(
                                backAction: {
                                    proxy.scrollWithAnimationTo(Steps.name)
                                },
                                completion: { text in
                                    task.description = text
                                    proxy.scrollWithAnimationTo(Steps.final)
                                }
                            )
                            Spacer()
                        }
                        .id(Steps.description)
                        .frame(width: screenSize.width)
                        
                        HStack {
                            Spacer()
                            TaskInitiationSummaryView(task: task) { task in
                                navigation.popToRoot()
                                // TODO: save to cache / remote
                            }
                            Spacer()
                        }
                        .id(Steps.final)
                        .frame(width: screenSize.width)
                    }
                }
            }
            .scrollDisabled(true)
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: {
            navigation.pop()
        }, label: {
            Image(systemName: "xmark").foregroundColor(.black)
        }))
    }
}

struct TaskInitiationView_Previews: PreviewProvider {
    static var previews: some View {
        TaskInitiationView(navigation: Navigation(), task: Task(name: "", description: "description"))
        TaskInitiationView(navigation: Navigation(), task: Task(name: "", description: "description"))
            .preferredColorScheme(.dark)
    }
}
