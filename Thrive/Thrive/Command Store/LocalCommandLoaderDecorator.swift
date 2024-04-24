//
//  LocalCommandLoaderDecorator.swift
//  Thrive
//
//  Created by Vadims Vorobjovs on 24/04/2024.
//

public class LocalCommandLoaderDecorator: CommandSerialization {
    private let decoratee: LocalCommandLoader
    
    public init(decoratee: LocalCommandLoader) {
        self.decoratee = decoratee
    }
    
    public func load(completion: @escaping (LoadResult) -> Void) {
        decoratee.load { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
    
    public func save(_ item: Command, completion: @escaping (SaveResult) -> Void) {
        decoratee.save(item) { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
    
    public func delete(_ item: Command, completion: @escaping (DeleteResult) -> Void) {
        decoratee.delete(item) { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
}
