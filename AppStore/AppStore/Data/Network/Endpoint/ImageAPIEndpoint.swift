//
//  ImageAPIEndpoint.swift
//  AppStore
//
//  Created by summercat on 2023/07/04.
//

import Foundation

struct ImageAPIEndpoint: Endpoint {
    typealias Response = Data
    
    let httpMethod: HTTPMethod = .get
    let baseURL: URL? = nil
    let path: String
    let parameters: [String: String] = [:]
}
