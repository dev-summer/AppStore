//
//  NetworkServiceTests.swift
//  AppStoreTests
//
//  Created by summercat on 2023/07/03.
//

@testable import AppStore
import XCTest

final class NetworkServiceTests: XCTestCase {
    private var sut: NetworkService!
    
    func test_requestSuccess() {
        // given
        let expectation = XCTestExpectation(description: "success")
        let endpoint = StubEndpoint(
            httpMethod: .get,
            baseURL: URL(string: "base"),
            path: "success"
        )
        let request = endpoint.urlRequest
        let response = HTTPURLResponse(
            url: (request?.url)!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: request?.allHTTPHeaderFields
        )
        let requestService = MockRequestService(
            data: Data(),
            response: response,
            error: nil
        )
        sut = DefaultNetworkService(requestService: requestService)
        
        // when
        _ = sut.request(request) { result in
            // then
            switch result {
            case .success:
                requestService.verify(request: endpoint.urlRequest)
                expectation.fulfill()
            case .failure:
                XCTFail()
            }
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_requestFailure_invalidURL() {
        // given
        let expectation = XCTestExpectation(description: "failure: invalid URL")
        let endpoint = StubEndpoint(
            httpMethod: .get,
            baseURL: URL(string: ""),
            path: "fail"
        )
        let request = endpoint.urlRequest
        sut = DefaultNetworkService()
        
        // when
        _ = sut.request(request) { result in
            // then
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error, NetworkError.invalidURL)
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_requestFailure_invalidRequest() {
        // given
        let expectation = XCTestExpectation(description: "failure: request error")
        let endpoint = StubEndpoint(
            httpMethod: .get,
            baseURL: URL(string: "test"),
            path: "fail"
        )
        let request = endpoint.urlRequest
        let response = HTTPURLResponse(
            url: (request?.url)!,
            statusCode: 500,
            httpVersion: nil,
            headerFields: request?.allHTTPHeaderFields
        )
        let requestService = MockRequestService(
            data: Data(),
            response: response,
            error: NetworkError.invalidRequest
        )
        sut = DefaultNetworkService(requestService: requestService)
        
        // when
        _ = sut.request(request) { result in
            // then
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error, NetworkError.invalidRequest)
                requestService.verify(request: request)
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_invalidResponse() {
        // given
        let expectation = XCTestExpectation(description: "failure: invalid response")
        let endpoint = StubEndpoint(
            httpMethod: .get,
            baseURL: URL(string: "test"),
            path: "fail"
        )
        let request = endpoint.urlRequest
        let requestService = MockRequestService(
            data: nil,
            response: nil,
            error: nil
        )
        sut = DefaultNetworkService(requestService: requestService)
        
        // when
        _ = sut.request(request) { result in
            // then
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error, NetworkError.invalidResponse)
                requestService.verify(request: request)
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_invalidStatusCode() {
        // given
        let expectation = XCTestExpectation(description: "failure: invalid HTTP status code")
        let endpoint = StubEndpoint(
            httpMethod: .get,
            baseURL: URL(string: "test"),
            path: "fail"
        )
        let request = endpoint.urlRequest
        let data = "data".data(using: .utf8)
        let response = HTTPURLResponse(
            url: (request?.url)!,
            statusCode: 300,
            httpVersion: nil,
            headerFields: request?.allHTTPHeaderFields
        )
        let requestService = MockRequestService(
            data: data,
            response: response,
            error: nil
        )
        sut = DefaultNetworkService(requestService: requestService)
        
        // when
        _ = sut.request(request) { result in
            // then
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error, NetworkError.invalidHTTPStatusCode(statusCode: 300))
                requestService.verify(request: request)
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_invalidData() {
        // given
        let expectation = XCTestExpectation(description: "failure: invalid data")
        let endpoint = StubEndpoint(
            httpMethod: .get,
            baseURL: URL(string: "test"),
            path: "fail"
        )
        let request = endpoint.urlRequest
        let response = HTTPURLResponse(
            url: (request?.url)!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: request?.allHTTPHeaderFields
        )
        let requestService = MockRequestService(
            data: nil,
            response: response,
            error: nil
        )
        sut = DefaultNetworkService(requestService: requestService)
        
        // when
        _ = sut.request(request) { result in
            // then
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error, NetworkError.invalidData)
                requestService.verify(request: request)
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 1)
    }
}
