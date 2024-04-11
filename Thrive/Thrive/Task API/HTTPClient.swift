//
//  HTTPClient.swift
//  Thrive
//
//  Created by Vadims Vorobjovs on 11/04/2024.
//

import Foundation

public protocol HTTPClient {
  typealias HTTPClientResult = Result<(Data, HTTPURLResponse), Error>
  
  func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void)
}
