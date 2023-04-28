//
//  TaskInitiationView.swift
//  ThriveApp
//
//  Created by Vadims Vorobjovs on 25/03/2023.
//

import SwiftUI

struct TaskInitiationView: View {
    
    private enum Steps: Hashable {
        case name
        case description
        case final
    }
    
    
    var body: some View {
        ZStack {
            BackgroundView()
            ScrollViewReader { proxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .center) {
                        
                        HStack {
                            Spacer()
                            TaskNameInitiationCell {
                                proxy.scrollWithAnimationTo(Steps.description)
                            } completion: { name in
                                
                            }.id(Steps.name)
                            Spacer()
                            
                        }.frame(width: screenSize.width)
                        
                        HStack {
                            Spacer()
                            TaskDescriptionInitiationCell(mainAction: {
                                proxy.scrollWithAnimationTo(Steps.final)
                            },
                                                          secondaryAction: {
                                proxy.scrollWithAnimationTo(Steps.name)
                            }).id(Steps.description)
                            
                            Spacer()
                        }.frame(width: screenSize.width)
                        
                        
                        HStack {
                            Spacer()
                            // TOOD: navigation
                            TaskInitiationSummaryView().id(Steps.final)
                            
                            
                            Spacer()
                        }.frame(width: screenSize.width)
                    }
                }
                .scrollDisabled(true)
            }
        }
    }
}

struct TaskInitiationView_Previews: PreviewProvider {
    static var previews: some View {
        TaskInitiationView()
    }
}

struct ProgressView: View {
    
    var body: some View {
        HStack {}
    }
    
}
