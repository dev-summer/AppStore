//
//  AppStoreAPIEndpoint.swift
//  AppStore
//
//  Created by summercat on 2023/07/03.
//

import Foundation

protocol AppStoreAPIEndpoint: Endpoint { }

extension AppStoreAPIEndpoint {
    var baseURL: URL? {
        return URL(string: "https://itunes.apple.com")
    }
}
