//
//  ContentView.swift
//  ThriveApp
//
//  Created by Vadims Vorobjovs on 24/03/2023.
//

import SwiftUI
import Thrive

struct AppTabViewRouter<Content: View>: View {
  let contentView: Content
  
  /// State
  @State private var showAlert = false
  
  var body: some View {
    contentView
  }
}

func makeTaskInitiationView(name: Binding<String>, completion: @escaping () -> Void) -> some View {
    return CommandNameInputView(name: name, onComplete: completion)
}

struct AppTabView_Previews: PreviewProvider {
    private static let loader = LocalCommandLoader(store: NullStore())
    private static let commandCreateView = CommandCreateView(model: model) { _ in }

    @ObservedObject static var model = CommandCreateViewModel(loader: loader)
    @ObservedObject static var mainTabModel = MainTabViewModel()
    
    static var previews: some View {
        let pathModel = CommandsViewModel(loader: loader)
        pathModel.commands = [
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
        
        let pathHistoryView = PathHistoryView(model: pathModel)
        
        return Group {
            AppTabViewRouter(contentView: pathHistoryView)
            AppTabViewRouter(contentView: pathHistoryView)
            .preferredColorScheme(.dark)
        }
    }
}
