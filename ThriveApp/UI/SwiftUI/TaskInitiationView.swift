//
//  TaskInitiationView.swift
//  ThriveApp
//
//  Created by Vadims Vorobjovs on 25/03/2023.
//

import SwiftUI

struct TaskInitiationView: View {
    private var navigation: Navigation
    
    init(navigation: Navigation) {
        self.navigation = navigation
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
                            TaskNameInitiationCell {
                                proxy.scrollWithAnimationTo(Steps.description)
                            } completion: { name in
                                
                            }
                            Spacer()
                        }
                        .id(Steps.name)
                        .frame(width: screenSize.width)
                        
                        HStack {
                            Spacer()
                            TaskDescriptionInitiationCell(
                                mainAction: { proxy.scrollWithAnimationTo(Steps.final) },
                                secondaryAction: { proxy.scrollWithAnimationTo(Steps.name) }
                            )
                            Spacer()
                        }
                        .id(Steps.description)
                        .frame(width: screenSize.width)
                        
                        HStack {
                            Spacer()
                            TaskInitiationSummaryView()
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
        TaskInitiationView(navigation: Navigation())
    }
}
