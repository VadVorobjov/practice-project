//
//  CommandLoaderCacheDecorator.swift
//  ThriveApp
//
//  Created by Vadims Vorobjovs on 11/04/2024.
//

public final class CommandLoaderCacheDecorator: CommandLoad {
  private let decoratee: CommandLoad
  private let cache: CommandSave
  
  public init(decoratee: CommandLoad, cache: CommandSave) {
    self.decoratee = decoratee
    self.cache = cache
  }
  
  public func load(completion: @escaping (CommandLoad.LoadResult) -> Void) {
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

