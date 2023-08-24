//
//  TaskInitiationView.swift
//  ThriveApp
//
//  Created by Vadims Vorobjovs on 25/03/2023.
//

import SwiftUI
import Thrive

struct TaskInitiationView: View {
    @ObservedObject var model: CommandCreateViewModel
    let complete: (CommandCreateViewModel?) -> Void
    
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
                            // TODO: should not depend?
                            TaskNameInitiationView(name: $model.commandName) {
                                proxy.scrollWithAnimationTo(Steps.description)
                            }
                            Spacer()
                        }
                        .id(Steps.name)
                        .frame(width: screenSize.width)

                        HStack {
                            Spacer()
                            TaskDescriptionInitiationView(
                                backAction: {
                                    proxy.scrollWithAnimationTo(Steps.name)
                                },
                                completion: { text in
                                    model.commandDescription = text
                                    proxy.scrollWithAnimationTo(Steps.final)
                                }
                            )
                            Spacer()
                        }
                        .id(Steps.description)
                        .frame(width: screenSize.width)

                        HStack {
                            Spacer()
                            TaskInitiationSummaryView(model: model, complete: complete)
                            Spacer()
                        }
                        .id(Steps.final)
                        .frame(width: screenSize.width)
                    }
                }
            }
            .scrollDisabled(true)
        }
        VStack {}
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: {
            complete(nil)
        }, label: {
            Image(systemName: "xmark").foregroundColor(.black)
        }))
    }
}

struct TaskInitiationView_Previews: PreviewProvider {
    private static let loader = LocalCommandLoader(store: NullStore())

    @ObservedObject static var model = CommandCreateViewModel(loader: loader)
    
    static var previews: some View {
        TaskInitiationView(model: model, complete: { _ in })
        TaskInitiationView(model: model, complete: { _ in })
            .preferredColorScheme(.dark)
    }
}
