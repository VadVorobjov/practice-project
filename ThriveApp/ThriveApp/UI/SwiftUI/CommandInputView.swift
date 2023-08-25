//
//  CommandInputView.swift
//  ThriveApp
//
//  Created by Vadims Vorobjovs on 25/03/2023.
//

import SwiftUI
import Thrive

struct CommandInputView: View {
    @ObservedObject var model: CommandCreateViewModel
    let onComplete: (CommandCreateViewModel?) -> Void
    
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
                                    CommandNameInputView(name: $model.commandName) {
                                        proxy.scrollWithAnimationTo(Steps.description)
                                    }
                                case .description:
                                    CommandDescriptionInputView(description: $model.commandDescription,
                                        onReverse: {
                                            proxy.scrollWithAnimationTo(Steps.name)
                                        },
                                        onComplete: {
                                            proxy.scrollWithAnimationTo(Steps.final)
                                        }
                                    )
                                case .final:
                                    CommandSummaryView(model: model, onComplete: onComplete)

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
        CommandInputView(model: model, onComplete: { _ in })
        CommandInputView(model: model, onComplete: { _ in })
            .preferredColorScheme(.dark)
    }
}
