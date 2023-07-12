//
//  DefaultAppRepository.swift
//  AppStore
//
//  Created by summercat on 2023/07/03.
//

import Foundation

final class DefaultAppRepository: AppRepository {
    private let dataTransferService: DataTransferService
    
    init(dataTransferService: DataTransferService = DefaultDataTransferService()) {
        self.dataTransferService = dataTransferService
    }
    
    func retrieveAppInfo(
        with id: Int,
        completion: @escaping (Result<App, DataTransferError>) -> Void
    ) -> URLSessionTask? {
        let endpoint: LookUpEndpoint = LookUpEndpoint(id: id)
        
        return dataTransferService.request(endpoint) { result in
            switch result {
            case .success(let responseDTO):
                responseDTO.results.forEach { completion(.success($0.toApp())) }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func retrieveAppList(
        with keyword: String,
        page: Int,
        pageSize: Int,
        completion: @escaping (Result<AppsPage, DataTransferError>) -> Void
    ) -> URLSessionTask? {
        let requestDTO: SearchRequestDTO = SearchRequestDTO(term: keyword, offset: page, limit: pageSize)
        let endpoint: SearchEndpoint = SearchEndpoint(with: requestDTO)
        
        return dataTransferService.request(endpoint) { result in
            switch result {
            case .success(let responseDTO):
                completion(.success(responseDTO.toAppsPage()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
