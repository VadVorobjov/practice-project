//
//  TaskStore.swift
//  Thrive
//
//  Created by Vadims Vorobjovs on 25/05/2023.
//

protocol TaskStore {
    typealias InsertionCompletion = (Error?) -> Void
    typealias DeletionCompletion = (Error?) -> Void

    func insert(_ item: Task, completion: @escaping InsertionCompletion)
    func delete(_ item: Task, completion: @escaping DeletionCompletion)
}
