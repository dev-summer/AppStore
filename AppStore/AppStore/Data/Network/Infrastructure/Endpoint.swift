//
//  Endpoint.swift
//  AppStore
//
//  Created by summercat on 2023/07/03.
//

import Foundation

protocol Endpoint {
    associatedtype Response: Decodable
    
    var httpMethod: HTTPMethod { get }
    var baseURL: URL? { get }
    var path: String { get }
    var parameters: [String: String] { get }
    var url: URL? { get }
}

extension Endpoint {
    var url: URL? {
        guard let url = self.baseURL?.appendingPathComponent(path) else { return nil }
        
        var components: URLComponents? = URLComponents(string: url.absoluteString)
        let queryItems = parameters.map { key, value in
            URLQueryItem(name: key, value: value)
        }
        components?.queryItems = queryItems
        
        return components?.url
    }
    
    var urlRequest: URLRequest? {
        guard let url = url else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        
        return request
    }
}
