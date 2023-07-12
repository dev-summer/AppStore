//
//  AppsPage+Equatable.swift
//  AppStoreTests
//
//  Created by summercat on 2023/07/04.
//

@testable import AppStore

extension AppsPage: Equatable {
    public static func == (lhs: AppsPage, rhs: AppsPage) -> Bool {
        if lhs.count == rhs.count,
           lhs.searchResults == rhs.searchResults {
            return true
        } else {
            return false
        }
    }
}
