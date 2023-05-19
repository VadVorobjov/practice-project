//
//  HomeView.swift
//  ThriveApp
//
//  Created by Vadims Vorobjovs on 16/05/2023.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject private var navigation = Navigation()
    
    var body: some View {
        NavigationStack(path: $navigation.path) {
            ZStack {
                customBackgroundView()
                
                NavigationLink(value: HomeNavigationType.name(navigation)) {
                    InitiationButtonSwiftUI(label: "Initiate") {
                        navigation.path.append(HomeNavigationType.name(navigation))
                    }
                }.navigationDestination(for: HomeNavigationType.self) { type in
                    type.view
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

private enum HomeNavigationType {
    case name(Navigation)
    case description(backAction: () -> Void, completion: (String) -> Void)
    
    var view: AnyView {
        switch self {
        case .name(let navigation):
            return AnyView(TaskInitiationView(
                navigation: navigation,
                task: Task(name: "", description: "")))
            
        case .description(let backAction, let completion):
            return AnyView(TaskDescriptionInitiationCell(
                backAction: backAction,
                completion: completion))
        }
    }
}

extension HomeNavigationType: Hashable {
    public func hash(into hasher: inout Hasher) {
        return hasher.combine(identifier)
    }
    
    var identifier: String {
        return UUID().uuidString
    }
    
    static func == (lhs: HomeNavigationType, rhs: HomeNavigationType) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}
