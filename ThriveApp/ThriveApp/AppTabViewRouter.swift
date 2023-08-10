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


struct AppTabViewRouter: View {
    @ObservedObject var mainTabModel: MainTabViewModel
    
    var body: some View {
        TabView(selection: $mainTabModel.tab) {
            ForEach (MainTabViewModel.Tab.allCases) { tab in
                switch tab {
                case .home:
                    NavigationView {
                        HomeView()
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
            AppTabViewRouter(mainTabModel: mainTabModel)
            AppTabViewRouter(mainTabModel: mainTabModel)
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
