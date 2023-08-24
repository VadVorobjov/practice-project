//
//  CommandSummaryView.swift
//  ThriveApp
//
//  Created by Vadims Vorobjovs on 04/04/2023.
//

import SwiftUI
import Thrive

struct CommandSummaryView: View {
    let model: CommandCreateViewModel
    let complete: (CommandCreateViewModel?) -> Void

    @State private var expandDescription = false

    var body: some View {
        ZStack(alignment: .top) {
            customBackgroundView()

            HStack(alignment: .top) {
                VStack(alignment: .center, spacing: 0) {
                    TitleTextView(title: model.commandName, font: .system(size: 24), fontWeight: .semibold)
                        .shadow(radius: 1, x: 1, y: 1)
                        .multilineTextAlignment(.center)

                    if !model.commandDescriptionIsEmpty {
                        VStack (alignment: .leading) {
                            Text(model.commandDescription)
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
                        Text("Some text")
                    }
                    .padding(.top)
                }
                .padding()
            }
        }
    }
}

struct TaskInitiationSummaryView_Previews: PreviewProvider {
    private static let loader = LocalCommandLoader(store: NullStore())
    @ObservedObject static private var model = CommandCreateViewModel(loader: loader)

    static var previews: some View {
        CommandSummaryView(model: model, complete: { _ in })
    }
}
