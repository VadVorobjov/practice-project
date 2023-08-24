//
//  CommandCreateView.swift
//  ThriveApp
//
//  Created by Vadims Vorobjovs on 25/03/2023.
//

import SwiftUI
import Thrive

struct CommandCreateView: View {
    @ObservedObject var model: CommandCreateViewModel
    let complete: (CommandCreateViewModel?) -> Void
    
    private enum Steps: Int, CaseIterable, Identifiable {
        var id: Int { rawValue }
        
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
                        ForEach(Steps.allCases) { step in
                            HStack {
                                Spacer()
                                
                                switch step {
                                case .name:
                                    TaskNameInitiationView(name: $model.commandName) {
                                        proxy.scrollWithAnimationTo(Steps.description)
                                    }
                                case .description:
                                    TaskDescriptionInitiationView(
                                        backAction: {
                                            proxy.scrollWithAnimationTo(Steps.name)
                                        },
                                        completion: { text in
                                            model.commandDescription = text
                                            proxy.scrollWithAnimationTo(Steps.final)
                                        }
                                    )
                                case .final:
                                    TaskInitiationSummaryView(model: model, complete: complete)

                                }
                                
                                Spacer()
                            }
                            .id(step)
                            .frame(width: screenSize.width)
                        }
                    }
                }
            }
            .scrollDisabled(true)
        }
        VStack {}
       
    }
}

struct TaskInitiationView_Previews: PreviewProvider {
    private static let loader = LocalCommandLoader(store: NullStore())

    @ObservedObject static var model = CommandCreateViewModel(loader: loader)
    
    static var previews: some View {
        CommandCreateView(model: model, complete: { _ in })
        CommandCreateView(model: model, complete: { _ in })
            .preferredColorScheme(.dark)
    }
}
