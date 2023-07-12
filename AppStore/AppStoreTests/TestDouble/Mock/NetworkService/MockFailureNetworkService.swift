//
//  MockFailureNetworkService.swift
//  AppStoreTests
//
//  Created by summercat on 2023/07/03.
//

@testable import AppStore
import XCTest

final class MockFailureNetworkService: NetworkService {
    private var callCount: Int = .zero
    private var request: URLRequest?
    private var error: NetworkError
    
    init(request: URLRequest?, error: NetworkError) {
        self.request = request
        self.error = error
    }
    
    func request(_ request: URLRequest?, completion: @escaping (Result<Data, NetworkError>) -> Void) -> URLSessionTask? {
        callCount += 1
        completion(.failure(error))
        
        return nil
    }
    
    func verify(callCount: Int = 1) {
        XCTAssertEqual(self.callCount, callCount)
    }
}
