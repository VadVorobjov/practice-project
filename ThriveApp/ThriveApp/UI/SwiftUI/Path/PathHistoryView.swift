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
    NavigationView {
      if model.commands.isEmpty {
        ProgressView("Loading...")
          .padding()
      } else {
        List(model.commands) { command in
          NavigationLink {
            PathHistoryDetailsView(model: CommandViewModel(command: command))
          } label: {
            PathHistoryItemView(model: CommandViewModel(command: command))
              .padding(.vertical, 5)
              .padding(.horizontal, 5)
          }
          .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
      }
    }
    .onAppear {
      model.loadCommands()
    }
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
