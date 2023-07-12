//
//  App+Equatable.swift
//  AppStoreTests
//
//  Created by summercat on 2023/07/03.
//

@testable import AppStore

extension App: Equatable {
    public static func == (lhs: App, rhs: App) -> Bool {
        return lhs.appID == rhs.appID
    }
}
