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

struct ContentView: View {
    private let navigation = Navigation()
    private let mainTabModel = MainTabViewModel()

    var body: some View {
        AppTabNavigation(navigation: navigation, mainTabModel: mainTabModel)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
