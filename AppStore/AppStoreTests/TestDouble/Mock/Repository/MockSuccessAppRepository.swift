//
//  MockSuccessAppRepository.swift
//  AppStoreTests
//
//  Created by summercat on 2023/07/04.
//

@testable import AppStore
import XCTest

final class MockSuccessAppRepository: AppRepository {
    private var app: App?
    private var appsPage: AppsPage?
    private var id: Int?
    private var keyword: String?
    private var page: Int?
    private var pageSize: Int?
    private var retrieveAppCallCount: Int = .zero
    private var retrieveAppListCallCount: Int = .zero
    
    init(app: App? = nil, appsPage: AppsPage? = nil) {
        self.app = app
        self.appsPage = appsPage
    }
    
    func retrieveAppInfo(
        with id: Int,
        completion: @escaping (Result<App, DataTransferError>) -> Void
    ) -> URLSessionTask? {
        self.id = id
        retrieveAppCallCount += 1
        completion(.success(app!))
        
        return nil
    }
    
    func retrieveAppList(
        with keyword: String,
        page: Int,
        pageSize: Int,
        completion: @escaping (Result<AppsPage, DataTransferError>) -> Void
    ) -> URLSessionTask? {
        self.keyword = keyword
        self.page = page
        self.pageSize = pageSize
        retrieveAppListCallCount += 1
        completion(.success(appsPage!))
        
        return nil
    }
    
    func verify(
        id: Int? = nil,
        keyword: String? = nil,
        page: Int? = nil,
        pageSize: Int? = nil,
        retrieveAppCallCount: Int = 0,
        retrieveAppListCallCount: Int = 0
    ) {
        XCTAssertEqual(self.id, id)
        XCTAssertEqual(self.keyword, keyword)
        XCTAssertEqual(self.page, page)
        XCTAssertEqual(self.pageSize, pageSize)
        XCTAssertEqual(self.retrieveAppCallCount, retrieveAppCallCount)
        XCTAssertEqual(self.retrieveAppListCallCount, retrieveAppListCallCount)
    }
}
