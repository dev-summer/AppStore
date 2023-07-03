//
//  DataTransferService.swift
//  AppStore
//
//  Created by summercat on 2023/07/03.
//

import Foundation

enum DataTransferError: Error {
    case decodingFailure
    case networkFailure(NetworkError)
}

extension DataTransferError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .decodingFailure:
            return "decoding error"
        case let .networkFailure(error):
            return error.localizedDescription
        }
    }
}

protocol DataTransferService {
    func request<E: Endpoint, T: Decodable>(
        _ endpoint: E,
        completion: @escaping (Result<T, DataTransferError>) -> Void
    ) -> URLSessionTask? where E.Response == T
    
    func requestJSONData<E: Endpoint>(
        _ endpoint: E,
        completion: @escaping (Result<E.Response, DataTransferError>) -> Void
    ) -> URLSessionTask?
}

final class DefaultDataTransferService: DataTransferService {
    private let networkService: NetworkService
    
    init(networkService: NetworkService = DefaultNetworkService()) {
        self.networkService = networkService
    }
    
    func request<E: Endpoint, T: Decodable>(
        _ endpoint: E,
        completion: @escaping (Result<T, DataTransferError>) -> Void
    ) -> URLSessionTask? where E.Response == T {
        return networkService.request(endpoint.urlRequest) { result in
            switch result {
            case .success(let data):
                let result: Result<T, DataTransferError> = self.decode(data)
                completion(result)
            case .failure(let error):
                completion(.failure(.networkFailure(error)))
            }
        }
    }
    
    func requestJSONData<E: Endpoint>(
        _ endpoint: E,
        completion: @escaping (Result<E.Response, DataTransferError>) -> Void
    ) -> URLSessionTask? {
        return networkService.request(endpoint.urlRequest) { result in
            switch result {
            case .success(let data):
                let result: Result<E.Response, DataTransferError> = self.decodeJSON(data)
                completion(result)
            case .failure(let error):
                completion(.failure(.networkFailure(error)))
            }
        }
    }
    
    private func decode<T: Decodable>(_ data: Data) -> Result<T, DataTransferError> {
        if T.self is Data.Type,
           let data = data as? T {
            return .success(data)
        } else {
            return .failure(.decodingFailure)
        }
    }
    
    private func decodeJSON<T: Decodable>(_ data: Data) -> Result<T, DataTransferError> {
        do {
            let result = try JSONDecoder().decode(T.self, from: data)
            return .success(result)
        } catch {
            return .failure(.decodingFailure)
        }
    }
}
