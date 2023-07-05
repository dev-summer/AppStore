//
//  MockFailureDataTransferService.swift
//  AppStoreTests
//
//  Created by summercat on 2023/07/04.
//

@testable import AppStore
import XCTest

final class MockFailureDataTransferService: DataTransferService {
    private var requestCallCount: Int = .zero
    private var requestJSONCallCount: Int = .zero
    private var error: DataTransferError
    
    init(error: DataTransferError) {
        self.error = error
    }
    
    func request<E: Endpoint>(
        _ endpoint: E,
        completion: @escaping (Result<E.Response, DataTransferError>) -> Void
    ) -> URLSessionTask? {
        requestJSONCallCount += 1
        completion(.failure(error))
        
        return nil
    }
    
    func verify(requestCallCount: Int = .zero, requestJSONCallCount: Int = .zero) {
        XCTAssertEqual(self.requestCallCount, requestCallCount)
        XCTAssertEqual(self.requestJSONCallCount, requestJSONCallCount)
    }
}
