//
//  SceneDelegate.swift
//  ThriveApp
//
//  Created by Vadims Vorobjovs on 14/03/2023.
//

import SwiftUI
import Thrive
import CoreData

enum NavigationType: Int, Hashable {
    case name
    case path
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
                commandCreateView: CommandCreateUIComposer.compossedWith(loader: loader),
                pathHistoryView: PathHistoryUIComposer.compossedWith(loader: loader)
            )
        )
        
        window.makeKeyAndVisible()
    }
}

struct PathHistoryUIComposer: View {
    @ObservedObject private var navigation: Navigation
    @ObservedObject private var model: CommandsViewModel
    
    static func compossedWith(loader: CommandLoader) -> some View {
        PathHistoryUIComposer(
            navigation: Navigation(),
            model: CommandsViewModel(loader: loader)
        )
    }
    
    var body: some View {
        PathHistoryView(model: model)
    }
}

/// Composer can be called only by other composers
struct CommandCreateUIComposer: View {
    @ObservedObject private var navigation: Navigation
    @ObservedObject private var model: CommandCreateViewModel
    
    @State private var presentAlert = false
    @State private var allertDescription: String = ""
    
    static func compossedWith(loader: CommandSerialization) -> some View {
        CommandCreateUIComposer(navigation: Navigation(), model: CommandCreateViewModel(loader: loader))
    }
    
    var body: some View {
        NavigationStack(path: $navigation.path) {
            NavigationLink(value: NavigationType.name) {
                ZStack {
                    customBackgroundView()
                    
                    CircleButton(label: "Initiation") {
                        navigation.path.append(NavigationType.name)
                    }
                }
            }
            .navigationDestination(for: NavigationType.self) { destination in
                if destination.rawValue == NavigationType.name.rawValue {
                    CommandCreateView(model: model) { model in
                        model.save() { result in
                            switch result {
                            case .success():
                                break
                            case .failure(let error):
                                allertDescription = error.localizedDescription
                                presentAlert.toggle()
                            }
                            navigation.popToRoot()
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
