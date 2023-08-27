//
//  SceneDelegate.swift
//  ThriveApp
//
//  Created by Vadims Vorobjovs on 14/03/2023.
//

import SwiftUI
import Thrive
import CoreData

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

class NullStore {}

extension NullStore: CommandStore {
    func insert(_ item: Thrive.LocalTask, completion: @escaping InsertionCompletion) {}
    
    func delete(_ item: Thrive.LocalTask, completion: @escaping DeletionCompletion) {}
    
    func retrieve(completion: @escaping RetrievalCompletion) {}
}

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    private lazy var store: CommandStore = {
        do {
            return try CoreDataTaskStore(
                storeURL: NSPersistentContainer
                    .defaultDirectoryURL()
                    .appendingPathComponent("command-store.sqlite"))
        }
        catch {
            assertionFailure("Failed to instantiate CoreData store with error \(error.localizedDescription)")
            return NullStore()
        }
    }()
    
    private lazy var loader: LocalCommandLoaderDecorator = {
        return LocalCommandLoaderDecorator(decoratee: LocalCommandLoader(store: store))
    }()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
     
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
                
        self.window = window
        
        window.rootViewController = UIHostingController(
            rootView: AppTabViewRouter(
                mainTabModel: MainTabViewModel(),
                commandCreateView: CommandCreateUIComposer.compossedWith(loader: loader)
            )
        )
        
        window.makeKeyAndVisible()
    }
}

/// Composer can be called only by other composers
struct CommandCreateUIComposer: View {
    @ObservedObject var navigation: Navigation
    @ObservedObject var model: CommandCreateViewModel
    
    @State private var presentAlert = false
    @State private var allertDescription: String = ""
    
    static func compossedWith(loader: CommandSerialization) -> some View {
        CommandCreateUIComposer(navigation: Navigation(), model: CommandCreateViewModel(loader: loader))
    }
    
    var body: some View {
        NavigationStack(path: $navigation.path) {
            NavigationLink(value: NavigationType.name) {
                InitiationButtonSwiftUI(label: "Initiation") {
                    navigation.path.append(NavigationType.name)
                }
            }
            .navigationDestination(for: NavigationType.self) { destination in
                switch destination {
                case .name:
                    CommandCreateView(model: model) { model in                        
                        model.save() { result in
                            switch result {
                            case .success():
                                break
                            case .failure(let error):
                                allertDescription = error.localizedDescription
                                presentAlert.toggle()
                            }
//                            DispatchQueue.main.async {
                                navigation.popToRoot()
//                            }
                        }
                    }
                    .modifier(NavigationModifier(navigationLeadingButtonAction: {
                        navigation.popToRoot()
                    }))
                }
            }
        }
        .alert("Something went wrong",
               isPresented: $presentAlert,
               presenting: allertDescription) { description in
            Text(description)
        }
    }
}
