//
//  TaskStoreSpecs.swift
//  ThriveTests
//
//  Created by Vadims Vorobjovs on 06/07/2023.
//

import Foundation

protocol TaskStoreSpecs {
    func test_retrieve_deliversEmptyOnEmptyStore()
    func test_retrieve_hasNoSideEffectsOnEmtpyStore()
    func test_retrieve_deliversFoundValuesOnNoneEmptyStore()
    func test_retrieve_hasNoSideEffectsOnNonEmptyStore()

    func test_insert_deliversNoErrorOnEmptyStore()
    func test_insert_applyValueToPrevioslyInsertedValues()

    func test_delete_hasNoSideEffectsOnEmptyStore()
    func test_delete_onNonEmptyStoreDeletesProvidedTask()

    func test_storeSideEffects_runSerially()
}

protocol FailableRetrieveTaskStoreSpecs: TaskStoreSpecs {
    func test_retrieve_deliversFailureOnRetrievalError()
    func test_retrieve_hasNoSideEffectsOnFailure()
}

protocol FailableInsertTaskStoreSpecs: TaskStoreSpecs {
    func test_insert_deliversErrorOnInsertionError()
    func test_insert_hasNoSideEffectsOnInsertionError()
}

protocol FailableDeleteTaskStoreSpecs: TaskStoreSpecs {
    func test_delete_deliversErrorOnFailure()
    func test_delete_hasNoSideEffectsOnDeletionError()
}

typealias FailableTaskStoreSpecs = FailableRetrieveTaskStoreSpecs & FailableInsertTaskStoreSpecs & FailableDeleteTaskStoreSpecs
