//
//  ContentView.swift
//  ThriveApp
//
//  Created by Vadims Vorobjovs on 24/03/2023.
//

import SwiftUI
import Thrive

struct AppTabViewRouter<Content: View>: View {
    @ObservedObject var mainTabModel: MainTabViewModel
    let commandCreateView: Content
    
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
            
            EmptyView()
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

    @ObservedObject static var model = CommandCreateViewModel(loader: loader)

    @ObservedObject static var mainTabModel = MainTabViewModel()
    static let commandCreateView = CommandCreateView(model: model) { _ in }
    
    static var previews: some View {
        Group {
            AppTabViewRouter(mainTabModel: mainTabModel, commandCreateView: commandCreateView)
            AppTabViewRouter(mainTabModel: mainTabModel, commandCreateView: commandCreateView)
                .preferredColorScheme(.dark)
        }
    }
}
