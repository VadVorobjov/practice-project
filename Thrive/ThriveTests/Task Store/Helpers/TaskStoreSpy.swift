//
//  TaskStoreSpy.swift
//  ThriveTests
//
//  Created by Vadims Vorobjovs on 29/05/2023.
//

import Thrive

class TaskStoreSpy: TaskStore {
    private var insertionCompletions = [InsertionCompletion]()
    private var deletionCompletions = [DeletionCompletion]()
    private var retrievalCompletions = [RetrievalCompletion]()
    
    enum ReceivedMessage: Equatable  {
        case insert(LocalTask)
        case delete(LocalTask)
        case retrieve
    }
    
    private(set) var receivedMessage: ReceivedMessage?
    
    func insert(_ item: LocalTask, completion: @escaping InsertionCompletion) {
        receivedMessage = .insert(item)
        insertionCompletions.append(completion)
    }
    
    func completeSave(with error: NSError, at index: Int = 0) {
        insertionCompletions[index](.failure(error))
    }
    
    func completeSaveSuccessfully(at index: Int = 0) {
        insertionCompletions[index](.success(()))
    }
    
    func delete(_ item: LocalTask, completion: @escaping DeletionCompletion) {
        receivedMessage = .delete(item)
        deletionCompletions.append(completion)
    }
    
    func completeDelete(with error: NSError, at index: Int = 0) {
        deletionCompletions[index](.failure(error))
    }
    
    func completeDeleteSuccessfully(at index: Int = 0) {
        deletionCompletions[index](.success(()))
    }
    
    func retrieve(completion: @escaping RetrievalCompletion) {
        receivedMessage = .retrieve
        retrievalCompletions.append(completion)
    }
    
    func completeRetrieval(with error: Error, at index: Int = 0) {
        retrievalCompletions[index](.failure(error))
    }

    func completeRetrieval(with items: [LocalTask], at index: Int = 0) {
        retrievalCompletions[index](.success(items))
    }
    
    func completeWithEmptyStore(at index: Int = 0) {
        retrievalCompletions[index](.success(.none))
    }
}
