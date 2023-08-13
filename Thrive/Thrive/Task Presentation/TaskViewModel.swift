//
//  TaskViewModel.swift
//  Thrive
//
//  Created by Vadims Vorobjovs on 10/08/2023.
//

import Foundation

public class TaskViewModel: ObservableObject {
    @Published public var name: String
    @Published public var description: String?
    
    public init(name: String, description: String?) {
        self.name = name
        self.description = description
    }
    
    public var hasDescription: Bool {
        if let description = description, !description.isEmpty {
            return true
        }
        
        return false
    }
    
//    public var description: String {
//        hasDescription ? description! : ""
//    }
}
