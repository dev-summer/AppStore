//
//  MockSuccessNetworkService.swift
//  AppStoreTests
//
//  Created by summercat on 2023/07/03.
//

@testable import AppStore
import XCTest

final class MockSuccessNetworkService: NetworkService {
    private var callCount: Int = .zero
    private var request: URLRequest?
    private var data: Data
    
    init(request: URLRequest?, data: Data) {
        self.request = request
        self.data = data
    }
    
    func request(_ request: URLRequest?, completion: @escaping (Result<Data, NetworkError>) -> Void) -> URLSessionTask? {
        callCount += 1
        completion(.success(data))
        
        return nil
    }
    
    func verify(callCount: Int = 1) {
        XCTAssertEqual(self.callCount, callCount)
    }
}
