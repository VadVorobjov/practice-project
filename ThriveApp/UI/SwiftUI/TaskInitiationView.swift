//
//  TaskInitiationView.swift
//  ThriveApp
//
//  Created by Vadims Vorobjovs on 25/03/2023.
//

import SwiftUI

extension ScrollViewProxy {
    func scrollWithAnimationTo<ID>(_ id: ID) where ID : Hashable {
        withAnimation {
            scrollTo(id)
        }
    }
}

struct TaskInitiationView: View {
    
    private enum Steps: Hashable {
        case name
        case description
        case final
    }
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal) {
                HStack(alignment: .center) {
                    
                    HStack {
                        Spacer()
                        TaskNameInitiationCell(action: {
                            proxy.scrollWithAnimationTo(Steps.description)
                        }).id(Steps.name)
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
                        
                        TaskInitiationSummaryView()
                        
                        Spacer()
                    }.frame(width: screenSize.width)
                }
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
