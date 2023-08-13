//
//  SceneDelegate.swift
//  ThriveApp
//
//  Created by Vadims Vorobjovs on 14/03/2023.
//

import SwiftUI
import Thrive

typealias ThriveTask = Thrive.Task

enum NavigationType: Hashable {
    case name
}

class MainTabViewModel: ObservableObject {
    @Published var tab: Tab = .home
    
    enum Tab: Int, CaseIterable, Identifiable {
        var id: Int { rawValue}

        case home
        case path
        case account
    }
}

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?

    let model = TaskViewModel(name: "", description: "")
    
    lazy var summaryView = {
        TaskInitiationSummaryView(model: self.model, complete: { _ in } )
    }

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
     
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        
        self.window = window
        
        window.rootViewController = UIHostingController(
            rootView: AppTabViewRouter(mainTabModel: MainTabViewModel(),
                                       model: model,
                                       taskNavigation: Navigation(),
                                       pathNavigation: Navigation(),
                                       accountNavigation: Navigation())
        )
        window.makeKeyAndVisible()
    }
}
