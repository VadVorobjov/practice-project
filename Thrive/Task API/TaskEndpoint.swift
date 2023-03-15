//
//  TaskEndpoint.swift
//  thrieve
//
//  Created by Vadims Vorobjovs on 09/02/2023.
//

import Foundation

public enum TaskEndpoint {
    case getTask(taskID: UUID)
    case getTasks
    case post
    
    public func url(baseURL: URL) -> URL {
        switch self {
        case let .getTask(taskID):
            var components = components(baseURL: baseURL)
            components.path = baseURL.path
            components.queryItems = [
                URLQueryItem(name: "task_id", value: "\(taskID.uuidString)")
            ]
            return components.url!
        case .getTasks:
            var components = components(baseURL: baseURL)
            components.path = baseURL.path + "/products"
            return components.url!
        case .post:
            var components = components(baseURL: baseURL)
            components.path = baseURL.path
            return components.url!
        }
    }
}

extension TaskEndpoint {
    private func components(baseURL: URL) -> URLComponents {
        var components = URLComponents()
        components.scheme = baseURL.scheme
        components.host = baseURL.host
        return components
    }
}
