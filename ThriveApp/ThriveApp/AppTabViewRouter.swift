//
//  ContentView.swift
//  ThriveApp
//
//  Created by Vadims Vorobjovs on 24/03/2023.
//

import SwiftUI

class MainTabViewModel: ObservableObject {
    @Published var tab: Tab = .home
    
    enum Tab: Int, CaseIterable, Identifiable {
        var id: Int { rawValue}

        case home
        case path
        case account
    }
}

enum TaskInitiation {
    case name
    
    var view: some View {
        switch self {
        case .name:
            return TaskInitiationView(navigation: Navigation(), task: Task(name: "", description: ""))
        }
    }
}


struct AppTabViewRouter: View {
    @ObservedObject var mainTabModel: MainTabViewModel
    @ObservedObject var navigation: Navigation
    
    var body: some View {
        TabView(selection: $mainTabModel.tab) {
            ForEach (MainTabViewModel.Tab.allCases) { tab in
                switch tab {
                case .home:
                    NavigationStack(path: $navigation.path) {
                        ZStack {
                            customBackgroundView()
                            
                            NavigationLink(value: TaskInitiation.name) {
                                InitiationButtonSwiftUI(label: "Initiate") {
                                    navigation.path.append(TaskInitiation.name)
                                }
                            }
                            
                            .navigationDestination(for: TaskInitiation.self) { view in
                                TaskInitiationView(navigation: navigation, task: Task(name: "", description: ""))
                            }
                        }
                        }
                    .tag(tab)
                    .tabItem { Label("Home", systemImage: "house.circle") }
                    
                case .path:
                    NavigationView {}
                        .tag(tab)
                        .tabItem { Label("Path", systemImage: "circle.dashed") }
                    
                case .account:
                    NavigationView {}
                        .tag(tab)
                        .tabItem { Label("Account", systemImage: "person.circle") }
                }
            }
        }
    }
}

struct AppTabView_Previews: PreviewProvider {
    static var navigation = Navigation()
    static var mainTabModel = MainTabViewModel()
    
    static var previews: some View {
        Group {
            AppTabViewRouter(mainTabModel: mainTabModel, navigation: navigation)
            AppTabViewRouter(mainTabModel: mainTabModel, navigation: navigation)
                .preferredColorScheme(.dark)
        }
    }
}

struct Task {
    var name: String
    var description: String
}

extension Task {
    static func dummyData() -> [Task] {
        return [
            Task(name: "Pet a cat", description: "Pet a cat by 6pm"),
            Task(name: "Buy airplane tickets", description: "Buy airplane ticket to Milan"),
            Task(name: "Check new car", description: "Check offers for new BMW")
        ]
    }
}
