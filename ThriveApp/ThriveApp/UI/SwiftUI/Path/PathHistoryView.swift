//
//  PathHistoryView.swift
//  ThriveApp
//
//  Created by Vadims Vorobjovs on 27/08/2023.
//

import SwiftUI
import Thrive

struct PathHistoryView: View {
    @ObservedObject private var model: CommandsViewModel
    
    init(model: CommandsViewModel) {
        self.model = model
    }
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 0) {
                ForEach(model.commands) { command in
                    PathHistoryItemView(model: CommandViewModel(command: command))
                        .padding(.vertical, 5)
                        .padding(.horizontal, 5)
                }
            }
            .scrollIndicators(.hidden)
            .onAppear {
                model.loadCommands()
            }
        }
        .background(Color.Background.primary)
        .toolbarBackground(Color.Background.primary, for: .tabBar)
    }
}

struct PathHistoryView_Preview: PreviewProvider {
    // TODO: unify duplications(CommandCreateView)
    static var previews: some View {
        let loader = LocalCommandLoader(store: NullStore())
        let model = CommandsViewModel(loader: loader)
        model.commands = [
            Command(name: "Walk Da Dog",
                    description: "description",
                    date: .init()),
            Command(name: "Pet Marcus",
                    description: "description",
                    date: .init()),
            Command(name: "Write to Sandra",
                    description: "description",
                    date: .init()),
            Command(name: "Pet Marcus",
                    description: "description",
                    date: .init()),
            Command(name: "Pet Marcus",
                    description: "description",
                    date: .init()),
            Command(name: "Pet Marcus",
                    description: "description",
                    date: .init())
        ]
        
        return PathHistoryView(model: model)
    }
}
