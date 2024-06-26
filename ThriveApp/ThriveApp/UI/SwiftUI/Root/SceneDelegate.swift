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
    
    private lazy var localLoader: LocalCommandLoaderDecorator = {
        return LocalCommandLoaderDecorator(decoratee: LocalCommandLoader(store: store))
    }()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
     
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
                
        self.window = window
      
      let url = URL(string: "https://gist.githubusercontent.com/VadVorobjov/5579da8aa31053d9eaf66943900b5c18/raw/48ee3f42df602972c0c70a2fdeff8197275658a3/gistfile1.json")!
      let session = URLSession(configuration: .ephemeral)
      
      let client = URLSessionHTTPClient(session: session)
      let remoteLoader = RemoteCommandLoader(url: url, client: client)
      
        window.rootViewController = UIHostingController(
          rootView: AppTabViewRouter(
            contentView: PathHistoryUIComposer.compossedWith(
              loader: CommandLoaderWithFallbackComposite(
                primary: CommandLoaderCacheDecorator(
                  decoratee: remoteLoader,
                  cache: localLoader),
                fallback: localLoader))
          )
        )
        
        window.makeKeyAndVisible()
    }
}

struct PathHistoryUIComposer: View {
    @ObservedObject private var navigation: Navigation
    @ObservedObject private var model: CommandsViewModel
    
    static func compossedWith(loader: CommandLoad) -> some View {
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
