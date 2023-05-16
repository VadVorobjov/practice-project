//
//  Navigation.swift
//  ThriveApp
//
//  Created by Vadims Vorobjovs on 01/05/2023.
//

import SwiftUI

final class Navigation: ObservableObject {
    @Published var path = NavigationPath()
    
    func pop() {
        guard path.count > 0 else { return }
        path.removeLast()
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
}
