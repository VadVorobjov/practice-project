//
//  CommandSerialization.swift
//  Thrive
//
//  Created by Vadims Vorobjovs on 24/04/2024.
//

public typealias CommandSerialization = CommandLoad & CommandSave & CommandDelete

public protocol CommandLoad {
    typealias LoadResult = Swift.Result<[Command], Error>
    
    func load(completion: @escaping (LoadResult) -> Void)
}

public protocol CommandSave {
    typealias SaveResult = Swift.Result<Void, Error>
    
    func save(_ item: Command, completion: @escaping (SaveResult) -> Void)
}

public protocol CommandDelete {
    typealias DeleteResult = Result<Void, Error>
    
    func delete(_ item: Command, completion: @escaping (DeleteResult) -> Void)
}
