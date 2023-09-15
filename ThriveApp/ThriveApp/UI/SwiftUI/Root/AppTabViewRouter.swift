//
//  ContentView.swift
//  ThriveApp
//
//  Created by Vadims Vorobjovs on 24/03/2023.
//

import SwiftUI
import Thrive

struct AppTabViewRouter<Content: View, Content1: View>: View {
    @ObservedObject var mainTabModel: MainTabViewModel
    let commandCreateView: Content
    let pathHistoryView: Content1
    
    /// State
    @State private var showAlert = false
    @State private var alertText = "" // TODO: should it really be `@State`
    
    var body: some View {
        TabView(selection: $mainTabModel.tab) {
            commandCreateView
                .tag(MainTabViewModel.Tab.home)
                .tabItem {
                    Label("Home", systemImage: "house.circle")
                }
            
            pathHistoryView
                .tag(MainTabViewModel.Tab.path)
                .tabItem {
                    Label("Path", systemImage: "circle.dashed")
                }
            
            RoundedRectangle(cornerRadius: 5)
                .tag(MainTabViewModel.Tab.account)
                .tabItem {
                    Label("Home", systemImage: "person.circle")
                }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Failed"),
                  message: Text(alertText),
                  dismissButton: .cancel()
            )
        }
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
            AppTabViewRouter(mainTabModel: mainTabModel,
                             commandCreateView: commandCreateView,
                             pathHistoryView: pathHistoryView)
            AppTabViewRouter(mainTabModel: mainTabModel,
                             commandCreateView: commandCreateView,
                             pathHistoryView: pathHistoryView)
            .preferredColorScheme(.dark)
        }
    }
}
