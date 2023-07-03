//
//  DefaultImageRepository.swift
//  AppStore
//
//  Created by summercat on 2023/07/04.
//

import Foundation

final class DefaultImageRepository: ImageRepository {
    static let shared: DefaultImageRepository = DefaultImageRepository()
    
    private let dataTransferService: DataTransferService
    private let cache: CacheStorage<Data>
    
    init(
        dataTransferService: DataTransferService = DefaultDataTransferService(),
        cache: CacheStorage<Data> = CacheStorage<Data>()
    ) {
        self.dataTransferService = dataTransferService
        self.cache = cache
    }
    
    func retrieveImage(
        with url: String,
        completion: @escaping (Result<Data, DataTransferError>) -> Void
    ) -> URLSessionTask? {
        if cache.isCached(url) {
            guard let cachedData = cache.fetch(for: url) else { return nil }
            
            completion(.success(cachedData))
            return nil
        } else {
            return fetchImage(with: url, completion: completion)
        }
    }
    
    private func fetchImage(
        with url: String,
        completion: @escaping (Result<Data, DataTransferError>) -> Void
    ) -> URLSessionTask? {
        let endpoint = ImageAPIEndpoint(path: url)
        
        return dataTransferService.request(endpoint) { [weak self] result in
            switch result {
            case .success(let data):
                self?.cache.store(data, for: url)
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
