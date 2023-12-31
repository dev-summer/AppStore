//
//  StubEndpoint.swift
//  AppStoreTests
//
//  Created by summercat on 2023/07/03.
//

@testable import AppStore
import Foundation

struct DummyModel: Decodable {
    let value: String
}

final class StubEndpointWithDecodableResponseType: Endpoint {
    typealias Response = DummyModel
    
    var httpMethod: HTTPMethod
    var baseURL: URL?
    var path: String
    var parameters: [String: String] = [:]
    
    init(httpMethod: HTTPMethod, baseURL: URL?, path: String) {
        self.httpMethod = httpMethod
        self.baseURL = baseURL
        self.path = path
    }
}

final class StubEndpointWithDataResponseType: Endpoint {
    typealias Response = Data
    
    var httpMethod: HTTPMethod
    var baseURL: URL?
    var path: String
    var parameters: [String: String] = [:]
    
    init(httpMethod: HTTPMethod, baseURL: URL?, path: String) {
        self.httpMethod = httpMethod
        self.baseURL = baseURL
        self.path = path
    }
}
