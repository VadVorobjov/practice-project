//
//  Command.swift
//  Thrive
//
//  Created by Vadims Vorobjovs on 21/05/2023.
//

public struct Command: Equatable, Identifiable {
    public let id: UUID
    public var name: String
    public let description: String?
    public let criterias: [Criteria]
    public let date: Date
    
    public init(id: UUID = UUID(), name: String, description: String? = nil, criterias: [Criteria] = [], date: Date) {
        self.id = id
        self.name = name
        self.description = description
        self.criterias = criterias
        self.date = date
    }
}

public struct Criteria: Equatable, Identifiable {
    public var id: UUID
    
    public let name: String
    public let isChecked: Bool
}
