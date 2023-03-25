//
//  AppTabNavigation.swift
//  ThriveApp
//
//  Created by Vadims Vorobjovs on 23/03/2023.
//

import SwiftUI

struct AppTabNavigation: View {
    
    private enum Tab {
        case home
        case path
        case account
    }
    
    @State private var selection: Tab = .home
    
    var body: some View {
        TabView(selection: $selection) {
            NavigationView {
                ZStack {
                    Color.background
                        .ignoresSafeArea()
                    InitiationButtonSwiftUI(label: "Initiate") {
                        print("Initiation button tapped")
                    }
                }
            }
            .tabItem {
                Label {
                    Text("Home")
                } icon: {
                    Image(systemName: "house.circle")
                }
            }
            .tag(Tab.home)
            
            NavigationView {
                
            }
            .tabItem {
                Label {
                    Text("Path")
                } icon: {
                    Image(systemName: "circle.dashed")
                }
            }
            .tag(Tab.path)
            
            NavigationView {
                
            }
            .tabItem {
                Label {
                    Text("Account")
                } icon: {
                    Image(systemName: "person.circle")
                }
            }
            .tag(Tab.account)
        }
        
    }
}

struct AppTabNavigation_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AppTabNavigation()
            AppTabNavigation()
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
