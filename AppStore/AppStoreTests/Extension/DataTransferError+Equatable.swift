//
//  DataTransferError+Equatable.swift
//  AppStoreTests
//
//  Created by summercat on 2023/07/03.
//

@testable import AppStore
import Foundation

extension DataTransferError: Equatable {
    public static func == (lhs: DataTransferError, rhs: DataTransferError) -> Bool {
        switch (lhs, rhs) {
        case (.decodingFailure, .decodingFailure):
            return true
        case let (.networkFailure(lhsError), .networkFailure(rhsError)):
            return lhsError == rhsError
        default:
            return false
        }
    }
}
