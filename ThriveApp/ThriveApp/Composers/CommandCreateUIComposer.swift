//
//  CommandCreateUIComposer.swift
//  ThriveApp
//
//  Created by Vadims Vorobjovs on 24/04/2024.
//

import Thrive
import SwiftUI

struct CommandCreateUIComposer: View {
    @ObservedObject private var navigation: Navigation
    @ObservedObject private var model: CommandCreateViewModel
    
    @State private var presentAlert = false
    @State private var allertDescription: String = ""
    
    static func compossedWith(loader: CommandSerialization) -> some View {
        CommandCreateUIComposer(navigation: Navigation(), model: CommandCreateViewModel(loader: loader))
    }
    
    var body: some View {
        NavigationStack(path: $navigation.path) {
            NavigationLink(value: NavigationType.name) {
                ZStack {
                    customBackgroundView()
                    
                    CircleButton(label: "Initiation") {
                        navigation.path.append(NavigationType.name)
                    }
                }
            }
            .navigationDestination(for: NavigationType.self) { destination in
                if destination.rawValue == NavigationType.name.rawValue {
                    CommandCreateView(model: model) { model in
                        model.save() { result in
                            switch result {
                            case .success():
                                break
                            case .failure(let error):
                                allertDescription = error.localizedDescription
                                presentAlert.toggle()
                            }
                            navigation.popToRoot()
                        }
                    }
                    .modifier(NavigationModifier(navigationLeadingButtonAction: {
                        navigation.popToRoot()
                    }))
                }
            }
        }
        .alert("Something went wrong",
               isPresented: $presentAlert,
               presenting: allertDescription) { description in
            Text(description)
        }
    }
}
