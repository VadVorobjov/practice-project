//
//  ContentView.swift
//  ThriveApp
//
//  Created by Vadims Vorobjovs on 24/03/2023.
//

import SwiftUI
import Thrive

struct AppTabViewRouter: View {
    @ObservedObject var mainTabModel: MainTabViewModel
    @ObservedObject var model: CommandViewModel
    
    /// Navigation DI
    @ObservedObject var taskNavigation: Navigation
    @ObservedObject var pathNavigation: Navigation
    @ObservedObject var accountNavigation: Navigation
    
    var body: some View {
        TabView(selection: $mainTabModel.tab) {
            NavigationStack(path: $taskNavigation.path) {
                
                NavigationLink(value: NavigationType.name) {
                    InitiationButtonSwiftUI(label: "Initiate") {
                        taskNavigation.path.append(NavigationType.name)
                    }
                    
                }
                .navigationDestination(for: NavigationType.self) { destination in
                    switch destination {
                    case .name:
                        TaskInitiationView(model: model) { task in
                            // If task is not `.none`
                            if task != .none {
                                // Save
                            }
                            
                            taskNavigation.popToRoot()
                        }
                        /// TODO: I need to compose whole views hierarchy, to be able to provide closure to the `TaskInitiationSummaryView`.
                    }
                }
            }
            .tag(MainTabViewModel.Tab.home)
            .tabItem {
                Label("Home", systemImage: "house.circle")
            }
            
            NavigationStack(path: $pathNavigation.path) {
                NavigationLink(value: NavigationType.name) {
                    InitiationButtonSwiftUI(label: "Second Init") {
                        pathNavigation.path.append(NavigationType.name)
                        
                    }
                }
                .navigationDestination(for: NavigationType.self) { destination in
                    switch destination {
                    case .name:
                        makeTaskInitiationView(name: $model.name) {
                        }
                    }
                }
            }
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
    }
}
func makeTaskInitiationView(name: Binding<String>, completion: @escaping () -> Void) -> some View {
    return TaskNameInitiationView(name: name, completion: completion)
}


struct AppTabView_Previews: PreviewProvider {
    @ObservedObject static var model = CommandViewModel(name: "", description: "")
    @ObservedObject static var navigation = Navigation()
    @ObservedObject static var secondNavigation = Navigation()

    @ObservedObject static var mainTabModel = MainTabViewModel()
    
    static var previews: some View {
        Group {
            AppTabViewRouter(mainTabModel: mainTabModel, model: model, taskNavigation: Navigation(), pathNavigation: Navigation(), accountNavigation: Navigation())
            AppTabViewRouter(mainTabModel: mainTabModel, model: model, taskNavigation: Navigation(), pathNavigation: Navigation(), accountNavigation: Navigation())
                .preferredColorScheme(.dark)
        }
    }
}
