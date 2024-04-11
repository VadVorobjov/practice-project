//
//  CommandLoaderWithFallbackComposite.swift
//  ThriveApp
//
//  Created by Vadims Vorobjovs on 11/04/2024.
//

import Thrive

public class CommandLoaderWithFallbackComposite: CommandLoader {
  private let primary: CommandLoader
  private let fallback: CommandLoader

  public init(primary: CommandLoader, fallback: CommandLoader) {
    self.primary = primary
    self.fallback = fallback
  }
  
  public func load(completion: @escaping (CommandLoader.LoadResult) -> Void) {
    primary.load { [weak self] result in
      switch result {
      case .success:
        completion(result)
        
      case .failure:
        self?.fallback.load(completion: completion)
      }
    }
  }
}
