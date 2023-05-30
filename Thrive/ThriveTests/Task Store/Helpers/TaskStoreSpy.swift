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
        insertionCompletions[index](error)
    }
    
    func completeSaveSuccessfully(at index: Int = 0) {
        insertionCompletions[index](nil)
    }
    
    func delete(_ item: LocalTask, completion: @escaping DeletionCompletion) {
        receivedMessage = .delete(item)
        deletionCompletions.append(completion)
    }
    
    func completeDelete(with error: NSError, at index: Int = 0) {
        deletionCompletions[index](error)
    }
    
    func completeDeleteSuccessfully(at index: Int = 0) {
        deletionCompletions[index](nil)
    }
    
    func retrieve(completion: @escaping RetrievalCompletion) {
        receivedMessage = .retrieve
        retrievalCompletions.append(completion)
    }
    
    func completeRetrieval(with error: Error, at index: Int = 0) {
        retrievalCompletions[index](error)
    }
    
    func completeRetrievalSuccessfully(at index: Int = 0) {
        retrievalCompletions[index](nil)
    }
}
