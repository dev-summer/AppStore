//
//  NetworkError+Equatable.swift
//  AppStoreTests
//
//  Created by summercat on 2023/07/03.
//

@testable import AppStore
import Foundation

extension NetworkError: Equatable {
    public static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidData, .invalidData),
            (.invalidResponse, .invalidResponse),
            (.invalidRequest, .invalidRequest),
            (.invalidURL, .invalidURL):
            return true
        case let (.invalidHTTPStatusCode(lhsCode), .invalidHTTPStatusCode(rhsCode)):
            return lhsCode == rhsCode
        default:
            return false
        }
    }
}
