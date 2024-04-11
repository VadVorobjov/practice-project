//
//  RemoteCommandLoader.swift
//  Thrive
//
//  Created by Vadims Vorobjovs on 11/04/2024.
//

import Foundation

public final class RemoteCommandLoader: CommandLoader {
  private let url: URL
  private let client: HTTPClient
  
  public enum Error: Swift.Error {
    case connectivity
    case invalidData
  }
  
  public typealias Result = CommandLoader.LoadResult
  
  public init(url: URL, client: HTTPClient) {
    self.url = url
    self.client = client
  }
  
  public func load(completion: @escaping (Result) -> Void) {
    client.get(from: url) { [weak self] result in
      guard self != nil else { return }
      
      switch result {
      case let .success((data, response)):
        completion(CommandItemsMapper.map(data, from: response))
      case .failure:
        completion(.failure(Error.connectivity))
      }
    }
  }
}
