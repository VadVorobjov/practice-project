//
//  CommandMapper.swift
//  Thrive
//
//  Created by Vadims Vorobjovs on 11/04/2024.
//

import Foundation

public final class CommandItemsMapper {
  private struct Root: Decodable {
    let items: [Item]
    
    var feed: [Command] {
      return items.map { $0.item }
    }
  }
  
  private struct Item: Decodable {
    let id: UUID
    let name: String
    let description: String?
    let date: Date
    
    var item: Command {
      return Command(id: id, name: name, description: description, date: date)
    }
  }
  
  private static var OK_200: Int { return 200 }
  private static var decoder: JSONDecoder {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    return decoder
  }
  
  internal static func map(_ data: Data, from response: HTTPURLResponse) -> RemoteCommandLoader.Result {
    guard response.statusCode == OK_200,
      let root = try? decoder.decode(Root.self, from: data) else {
      return .failure(RemoteCommandLoader.Error.invalidData)
    }

    return .success(root.feed)
  }
}
