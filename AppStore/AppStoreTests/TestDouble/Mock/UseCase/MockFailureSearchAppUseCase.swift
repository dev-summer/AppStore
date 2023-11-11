//
//  MockFailureSearchAppUseCase.swift
//  AppStoreTests
//
//  Created by summercat on 2023/11/11.
//

@testable import AppStore
import XCTest

final class MockFailureSearchAppUseCase: SearchAppUseCase {
    private var error: DataTransferError
    private var searchAppCallCount: Int = 0
    private var searchAppListCallCount: Int = 0
    
    init(error: DataTransferError) {
        self.error = error
    }
    
    func searchApp(
        with id: Int,
        completion: @escaping (Result<App, DataTransferError>) -> Void
    ) -> URLSessionTask? {
        searchAppCallCount += 1
        completion(.failure(error))
        
        return nil
    }
    
    func searchAppList(
        with keyword: String,
        page: Int,
        pageSize: Int,
        completion: @escaping (Result<AppsPage, DataTransferError>) -> Void
    ) -> URLSessionTask? {
        searchAppListCallCount += 1
        completion(.failure(error))
        
        return nil
    }
    
    func verify(searchAppCallCount: Int = 0, searchAppListCallCount: Int = 0) {
        XCTAssertEqual(searchAppCallCount, searchAppCallCount)
        XCTAssertEqual(searchAppListCallCount, searchAppListCallCount)
    }
}
