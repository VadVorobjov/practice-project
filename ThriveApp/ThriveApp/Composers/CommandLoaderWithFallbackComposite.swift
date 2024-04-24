//
//  CommandLoaderWithFallbackComposite.swift
//  ThriveApp
//
//  Created by Vadims Vorobjovs on 11/04/2024.
//

import Thrive

public class CommandLoaderWithFallbackComposite: CommandLoad {
  private let primary: CommandLoad
  private let fallback: CommandLoad

  public init(primary: CommandLoad, fallback: CommandLoad) {
    self.primary = primary
    self.fallback = fallback
  }
  
  public func load(completion: @escaping (CommandLoad.LoadResult) -> Void) {
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
