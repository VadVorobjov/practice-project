//
//  AppTabNavigation.swift
//  ThriveApp
//
//  Created by Vadims Vorobjovs on 23/03/2023.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var navigation: Navigation
    
    var body: some View {
        NavigationStack(path: $navigation.path) {
            ZStack {
                BackgroundView()
                
                NavigationLink(value: TaskInitiationNavigationType.name(navigation)) {
                    InitiationButtonSwiftUI(label: "Initiate") {
                        navigation.path.append(TaskInitiationNavigationType.name(navigation))
                    }
                }.navigationDestination(for: TaskInitiationNavigationType.self) { type in
                    type.view
                        .transition(.move(edge: .top)).id(UUID())
                }
            }
        }
    }
}

struct AppTabNavigation: View {
    @ObservedObject var navigation: Navigation
    @ObservedObject var mainTabModel: MainTabViewModel
    
    var body: some View {
        TabView(selection: $mainTabModel.tab) {
            ForEach (MainTabViewModel.Tab.allCases) { tab in
                switch tab {
                case .home:
                    NavigationView {
                        HomeView(navigation: navigation)
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

struct AppTabNavigation_Previews: PreviewProvider {
    static var navigation = Navigation()
    static var mainTabModel = MainTabViewModel()
    
    static var previews: some View {
        Group {
            AppTabNavigation(navigation: navigation, mainTabModel: mainTabModel)
            AppTabNavigation(navigation: navigation, mainTabModel: mainTabModel)
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

enum TaskInitiationNavigationType {
    case name(Navigation)
    case description
    
    var view: AnyView {
        switch self {
        case .name(let navigation):
            return AnyView(TaskInitiationView(navigation: navigation))
        case .description:
            return AnyView(TaskDescriptionInitiationCell(mainAction: {}, secondaryAction: {}))
        }
    }
}

extension TaskInitiationNavigationType: Hashable {
    public func hash(into hasher: inout Hasher) {
        return hasher.combine(identifier)
    }
    
    var identifier: String {
        return UUID().uuidString
    }
    
    static func == (lhs: TaskInitiationNavigationType, rhs: TaskInitiationNavigationType) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}
