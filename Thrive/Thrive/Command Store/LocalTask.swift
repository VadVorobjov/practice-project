//
//  LocalTask.swift
//  Thrive
//
//  Created by Vadims Vorobjovs on 24/04/2024.
//

public struct LocalTask: Equatable {
    public let id: UUID
    public let name: String
    public let description: String?
    public let date: Date
    
    public init(id: UUID, name: String, description: String? = nil, date: Date) {
        self.id = id
        self.name = name
        self.description = description
        self.date = date
    }
}
