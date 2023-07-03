//
//  MockRequestService.swift
//  AppStoreTests
//
//  Created by summercat on 2023/07/03.
//

@testable import AppStore
import XCTest

final class MockRequestService: RequestService {
    let data: Data?
    let response: HTTPURLResponse?
    let error: Error?
    private var request: URLRequest?
    private var callCount: Int = .zero
    
    init(data: Data?, response: HTTPURLResponse?, error: Error?) {
        self.data = data
        self.response = response
        self.error = error
    }
    
    func request(
        _ request: URLRequest,
        completion: @escaping (Data?, URLResponse?, Error?) -> Void
    ) -> URLSessionTask {
        self.request = request
        callCount += 1
        completion(data, response, error)
        return URLSession(configuration: .ephemeral).dataTask(with: request)
    }
    
    func verify(request: URLRequest?, callCount: Int = 1) {
        XCTAssertEqual(self.request, request)
        XCTAssertEqual(self.callCount, callCount)
    }
}
