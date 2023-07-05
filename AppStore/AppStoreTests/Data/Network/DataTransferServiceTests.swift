//
//  DataTransferServiceTests.swift
//  AppStoreTests
//
//  Created by summercat on 2023/07/03.
//

@testable import AppStore
import XCTest

final class DataTransferServiceTests: XCTestCase {
    private var sut: DataTransferService!
    
    func test_requestJSON_decodingSuccess_validJSONResponse() {
        // given
        let expectation = XCTestExpectation(description: "success")
        let endpoint = StubEndpointWithDecodableResponseType(
            httpMethod: .get,
            baseURL: URL(string: "base"),
            path: String.init()
        )
        let request = endpoint.urlRequest
        let data = #"{"value": "Hello"}"#.data(using: .utf8)!
        let networkService = MockSuccessNetworkService(
            request: request,
            data: data
        )
        sut = DefaultDataTransferService(networkService: networkService)
        
        // when
        _ = sut.request(endpoint) { result in
            // then
            switch result {
            case .success(let data):
                XCTAssertEqual(data.value, "Hello")
                networkService.verify()
                expectation.fulfill()
            case .failure:
                XCTFail()
            }
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_requestJSON_decodingFailure() {
        // given
        let expectation = XCTestExpectation(description: "failure")
        let endpoint = StubEndpointWithDecodableResponseType(
            httpMethod: .get,
            baseURL: URL(string: "base"),
            path: String.init()
        )
        let request = endpoint.urlRequest
        let data = #"{"invalidResponse": "Hello"}"#.data(using: .utf8)!
        let networkService = MockSuccessNetworkService(
            request: request,
            data: data
        )
        sut = DefaultDataTransferService(networkService: networkService)
        
        // when
        _ = sut.request(endpoint) { result in
            // then
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error, .decodingFailure)
                networkService.verify()
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_requestJSON_networkFailure() {
        // given
        let expectation = XCTestExpectation(description: "failure")
        let endpoint = StubEndpointWithDecodableResponseType(
            httpMethod: .get,
            baseURL: URL(string: "base"),
            path: String.init()
        )
        let request = endpoint.urlRequest
        let networkService = MockFailureNetworkService(request: request, error: .invalidResponse)
        sut = DefaultDataTransferService(networkService: networkService)
        
        // when
        _ = sut.request(endpoint) { result in
            // then
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error, .networkFailure(.invalidResponse))
                networkService.verify()
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 1)
    }
}
