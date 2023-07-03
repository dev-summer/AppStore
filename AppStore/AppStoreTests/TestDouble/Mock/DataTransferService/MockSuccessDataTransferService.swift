//
//  MockSuccessDataTransferService.swift
//  AppStoreTests
//
//  Created by summercat on 2023/07/04.
//

@testable import AppStore
import XCTest

final class MockSuccessDataTransferService: DataTransferService {
    private var requestCallCount: Int = .zero
    private var requestJSONCallCount: Int = .zero
    private var responseDTO: ResponseDTO?
    
    init(responseDTO: ResponseDTO? = nil) {
        self.responseDTO = responseDTO
    }
    
    func request<E: Endpoint, T: Decodable>(
        _ endpoint: E,
        completion: @escaping (Result<T, DataTransferError>) -> Void
    ) -> URLSessionTask? where T == E.Response {
        requestCallCount += 1
        
        return nil
    }
    
    func requestJSONData<E: Endpoint>(
        _ endpoint: E,
        completion: @escaping (Result<E.Response, DataTransferError>) -> Void
    ) -> URLSessionTask? {
        requestJSONCallCount += 1
        completion(.success(responseDTO as! E.Response))
        
        return nil
    }
    
    func verify(requestCallCount: Int = .zero, requestJSONCallCount: Int = .zero) {
        XCTAssertEqual(self.requestCallCount, requestCallCount)
        XCTAssertEqual(self.requestJSONCallCount, requestJSONCallCount)
    }
}
