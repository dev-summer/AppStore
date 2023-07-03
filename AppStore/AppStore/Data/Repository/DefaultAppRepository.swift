//
//  DefaultAppRepository.swift
//  AppStore
//
//  Created by summercat on 2023/07/03.
//

import Foundation

final class DefaultAppRepository: AppRepository {
    static let shared: DefaultAppRepository = DefaultAppRepository()
    
    private let dataTransferService: DataTransferService
    private let appResponseCache: CacheStorage<AppResponse>
    private let appListCache: CacheStorage<ResponseDTO>
    
    init(
        dataTransferService: DataTransferService = DefaultDataTransferService(),
        appResponseCache: CacheStorage<AppResponse> = CacheStorage<AppResponse>(),
        appListCache: CacheStorage<ResponseDTO> = CacheStorage<ResponseDTO>()
    ) {
        self.dataTransferService = dataTransferService
        self.appResponseCache = appResponseCache
        self.appListCache = appListCache
    }
    
    func retrieveAppInfo(
        with id: Int,
        completion: @escaping (Result<App, DataTransferError>) -> Void
    ) -> URLSessionTask? {
        if appResponseCache.isCached(id) {
            guard let cachedData = appResponseCache.fetch(for: id) else { return nil }
            
            completion(.success(cachedData.toApp()))
            return nil
        } else {
            return fetchAppInfo(with: id, completion: completion)
        }
    }
    
    func retrieveAppList(
        with keyword: String,
        page: Int,
        pageSize: Int,
        completion: @escaping (Result<AppsPage, DataTransferError>) -> Void
    ) -> URLSessionTask? {
        let requestDTO: SearchRequestDTO = SearchRequestDTO(
            term: keyword,
            offset: page,
            limit: pageSize
        )
        
        if appListCache.isCached(requestDTO) {
            guard let cachedData = appListCache.fetch(for: requestDTO) else { return nil }
            
            completion(.success(cachedData.toAppsPage()))
            return nil
        } else {
            return fetchAppList(with: requestDTO, completion: completion)
        }
    }
    
    private func fetchAppInfo(
        with id: Int,
        completion: @escaping (Result<App, DataTransferError>) -> Void
    ) -> URLSessionTask? {
        let endpoint: LookUpEndpoint = LookUpEndpoint(id: id)
        
        return dataTransferService.requestJSONData(endpoint) { [weak self] result in
            switch result {
            case .success(let responseDTO):
                responseDTO.results.forEach {
                    self?.appResponseCache.store($0, for: $0.appID)
                    completion(.success($0.toApp()))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func fetchAppList(
        with requestDTO: SearchRequestDTO,
        completion: @escaping (Result<AppsPage, DataTransferError>) -> Void
    ) -> URLSessionTask? {
        let endpoint: SearchEndpoint = SearchEndpoint(with: requestDTO)
        
        return dataTransferService.requestJSONData(endpoint) { [weak self] result in
            switch result {
            case .success(let responseDTO):
                self?.appListCache.store(responseDTO, for: requestDTO)
                responseDTO.results.forEach {
                    guard let self = self else { return }
                    
                    if !self.appResponseCache.isCached($0.appID) {
                        self.appResponseCache.store($0, for: $0.appID)
                    }
                }
                completion(.success(responseDTO.toAppsPage()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
