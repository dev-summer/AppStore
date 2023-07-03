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
            path: .init()
        )
        let request = endpoint.urlRequest
        let data = #"{"value": "Hello"}"#.data(using: .utf8)!
        let networkService = MockSuccessNetworkService(
            request: request,
            data: data
        )
        sut = DefaultDataTransferService(networkService: networkService)
        
        // when
        _ = sut.requestJSONData(endpoint) { result in
            // then
            switch result {
            case .success(let data):
                XCTAssertEqual(data.value, "Hello")
                networkService.verify(callCount: 1)
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
            path: .init()
        )
        let request = endpoint.urlRequest
        let data = #"{"invalidResponse": "Hello"}"#.data(using: .utf8)!
        let networkService = MockSuccessNetworkService(
            request: request,
            data: data
        )
        sut = DefaultDataTransferService(networkService: networkService)
        
        // when
        _ = sut.requestJSONData(endpoint) { result in
            // then
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error, .decodingFailure)
                networkService.verify(callCount: 1)
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
            path: .init()
        )
        let request = endpoint.urlRequest
        let networkService = MockFailureNetworkService(request: request, error: .invalidResponse)
        sut = DefaultDataTransferService(networkService: networkService)
        
        // when
        _ = sut.requestJSONData(endpoint) { result in
            // then
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error, .networkFailure(.invalidResponse))
                networkService.verify(callCount: 1)
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_request_decodingSuccess_validDataResponse() {
        // given
        let expectation = XCTestExpectation(description: "success")
        let endpoint = StubEndpointWithDataResponseType(
            httpMethod: .get,
            baseURL: URL(string: "base"),
            path: .init()
        )
        let request = endpoint.urlRequest
        let data = #"{"value": "Hello"}"#.data(using: .utf8)!
        let networkService = MockSuccessNetworkService(
            request: request,
            data: data
        )
        sut = DefaultDataTransferService(networkService: networkService)
        
        // when
        _ = sut.request(endpoint, completion: { result in
            // then
            switch result {
            case .success(let data):
                XCTAssertEqual(data, data)
                networkService.verify(callCount: 1)
                expectation.fulfill()
            case .failure:
                XCTFail()
            }
        })
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_request_decodingFailure() {
        // given
        let expectation = XCTestExpectation(description: "failure")
        let endpoint = StubEndpointWithDecodableResponseType(
            httpMethod: .get,
            baseURL: URL(string: "base"),
            path: .init()
        )
        let request = endpoint.urlRequest
        let data = #"{"value": "Hello"}"#.data(using: .utf8)!
        let networkService = MockSuccessNetworkService(
            request: request,
            data: data
        )
        sut = DefaultDataTransferService(networkService: networkService)
        
        // when
        _ = sut.request(endpoint, completion: { result in
            // then
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error, .decodingFailure)
                networkService.verify(callCount: 1)
                expectation.fulfill()
            }
        })
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_request_networkFailure() {
        // given
        let expectation = XCTestExpectation(description: "failure")
        let endpoint = StubEndpointWithDataResponseType(
            httpMethod: .get,
            baseURL: URL(string: "base"),
            path: .init()
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
                networkService.verify(callCount: 1)
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 1)
    }
}

final class MockSuccessNetworkService: NetworkService {
    private var callCount: Int = 0
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
    
    func verify(callCount: Int = 0) {
        XCTAssertEqual(self.callCount, callCount)
    }
}

final class MockFailureNetworkService: NetworkService {
    private var callCount: Int = 0
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
    
    func verify(callCount: Int = 0) {
        XCTAssertEqual(self.callCount, callCount)
    }
}
