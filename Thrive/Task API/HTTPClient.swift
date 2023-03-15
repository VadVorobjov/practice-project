//
//  HTTPClient.swift
//  thrieve
//
//  Created by Vadims Vorobjovs on 09/02/2023.
//

import Foundation

public protocol HTTPClientTask {
    func cancel()
}

protocol HTTPClient {
    typealias Result = Swift.Result<(Data?, HTTPURLResponse), Error>
    
    func get(from url: URL, completion: @escaping (Result) -> Void) -> HTTPClientTask
    func send(to url: URL, completion: @escaping (Result) -> Void)
}
