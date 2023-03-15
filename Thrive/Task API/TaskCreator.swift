//
//  TaskCreator.swift
//  thrieve
//
//  Created by Vadims Vorobjovs on 06/02/2023.
//

import Foundation

protocol Creatable {
    associatedtype Resource
    
    func create() -> Resource
}
