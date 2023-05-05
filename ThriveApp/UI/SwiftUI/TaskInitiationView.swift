//
//  TaskInitiationView.swift
//  ThriveApp
//
//  Created by Vadims Vorobjovs on 25/03/2023.
//

import SwiftUI

struct TaskInitiationView: View {
    private var navigation: Navigation
    @State private var task: Task // TODO: got a feeling, that this should be handled by `presenter` or maybe `viewModel`
    
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
            BackgroundView()
            ScrollView(.horizontal, showsIndicators: false) {
                ScrollViewReader { proxy in
                    HStack(alignment: .center) {
                        
                        HStack {
                            Spacer()
                            TaskNameInitiationCell { text in
                                task.name = text
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
                        
//                        HStack {
//                            Spacer()
//                            TaskInitiationSummaryView()
//                            Spacer()
//                        }
//                        .id(Steps.final)
//                        .frame(width: screenSize.width)
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
        TaskInitiationView(navigation: Navigation(), task: Task(name: "name", description: "description"))
    }
}
