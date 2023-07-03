//
//  NetworkService.swift
//  AppStore
//
//  Created by summercat on 2023/07/03.
//

import Foundation

enum NetworkError: Error {
    case invalidData
    case invalidHTTPStatusCode(statusCode: Int)
    case invalidResponse
    case invalidRequest
    case invalidURL
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidData:
            return "invalid data"
        case .invalidHTTPStatusCode(let statusCode):
            return "invalid HTTP status code \(statusCode)"
        case .invalidResponse:
            return "invalid response"
        case .invalidRequest:
            return "invalid request"
        case .invalidURL:
            return "invalid URL"
        }
    }
}

protocol NetworkService {
    func request(
        _ request: URLRequest?,
        completion: @escaping (Result<Data, NetworkError>) -> Void
    ) -> URLSessionTask?
}

final class DefaultNetworkService: NetworkService {
    private let requestService: RequestService
    
    init(requestService: RequestService = DefaultRequestService()) {
        self.requestService = requestService
    }
    
    func request(
        _ request: URLRequest?,
        completion: @escaping (Result<Data, NetworkError>) -> Void
    ) -> URLSessionTask? {
        guard let request else {
            completion(.failure(.invalidURL))
            return nil
        }
        
        let task = requestService.request(request) { data, response, error in
            guard error == nil else {
                completion(.failure(.invalidRequest))
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard (200..<300) ~= response.statusCode else {
                completion(.failure(.invalidHTTPStatusCode(statusCode: response.statusCode)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            completion(.success(data))
        }
        task.resume()
        
        return task
    }
}
