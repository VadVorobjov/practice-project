//
//  CommandLoaderCacheDecorator.swift
//  ThriveApp
//
//  Created by Vadims Vorobjovs on 11/04/2024.
//

public final class CommandLoaderCacheDecorator: CommandLoader {
  private let decoratee: CommandLoader
  private let cache: CommandSave
  
  public init(decoratee: CommandLoader, cache: CommandSave) {
    self.decoratee = decoratee
    self.cache = cache
  }
  
  public func load(completion: @escaping (CommandLoader.LoadResult) -> Void) {
    decoratee.load { [weak self] result in
      completion(result.map { items in
        self?.cache.saveIgnoringResult(items)
        return items
      })
    }
  }
}

private extension CommandSave {
  func saveIgnoringResult(_ items: [Command]) {
    _ = items.map { save($0) { _ in } }
  }
}

