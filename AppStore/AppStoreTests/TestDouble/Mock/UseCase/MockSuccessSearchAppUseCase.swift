//
//  MockSuccessSearchAppUseCase.swift
//  AppStoreTests
//
//  Created by summercat on 2023/11/11.
//

@testable import AppStore
import XCTest

final class MockSuccessSearchAppUseCase: SearchAppUseCase {
    private var app: App
    private var searchAppCallCount: Int = 0
    private var searchAppListCallCount: Int = 0
    
    init(app: App) {
        self.app = app
    }
    
    func searchApp(
        with id: Int,
        completion: @escaping (Result<App, DataTransferError>) -> Void
    ) -> URLSessionTask? {
        searchAppCallCount += 1
        completion(.success(app))
        
        return nil
    }
    
    func searchAppList(
        with keyword: String,
        page: Int,
        pageSize: Int,
        completion: @escaping (Result<AppsPage, DataTransferError>) -> Void
    ) -> URLSessionTask? {
        let appsPage: AppsPage = AppsPage(count: 1, searchResults: [app])
        searchAppListCallCount += 1
        completion(.success(appsPage))
        
        return nil
    }
    
    func verify(searchAppCallCount: Int = 0, searchAppListCallCount: Int = 0) {
        XCTAssertEqual(searchAppCallCount, searchAppCallCount)
        XCTAssertEqual(searchAppListCallCount, searchAppListCallCount)
    }
}
