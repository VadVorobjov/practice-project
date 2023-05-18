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

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
