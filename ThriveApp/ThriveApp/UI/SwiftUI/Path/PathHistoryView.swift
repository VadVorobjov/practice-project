//
//  PathHistoryView.swift
//  ThriveApp
//
//  Created by Vadims Vorobjovs on 27/08/2023.
//

import SwiftUI
import Thrive

struct PathHistoryView: View {
    @ObservedObject private var model: CommandViewModel
    
    init(model: CommandViewModel) {
        self.model = model
    }
    
    var body: some View {
        VStack {
            List(model.commands) { command in
                Text(command.name)
            }
        }
    }
}

struct PathHistoryView_Preview: PreviewProvider {
    // TODO: unify duplications(CommandCreateView)
    static var previews: some View {
        let loader = LocalCommandLoader(store: NullStore())
        let model = CommandViewModel(loader: loader)
        model.commands = [
            Command(name: "Walk Da Dog", description: "description", date: .init()),
            Command(name: "Pet Marcus", description: "description", date: .init()),
            Command(name: "Write to Sandra", description: "description", date: .init())
        ]
        
        return PathHistoryView(model: model)
            .environmentObject(model)
    }
    
}
