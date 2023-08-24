//
//  Command.swift
//  Thrive
//
//  Created by Vadims Vorobjovs on 21/05/2023.
//

public struct Command: Equatable {
    public let id: UUID
    public var name: String
    public let description: String?
    public let date: Date
    
    public init(id: UUID = UUID(), name: String, description: String? = nil, date: Date) {
        self.id = id
        self.name = name
        self.description = description
        self.date = date
    }
}
