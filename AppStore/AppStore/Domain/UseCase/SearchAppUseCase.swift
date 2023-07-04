//
//  SearchAppUseCase.swift
//  AppStore
//
//  Created by summercat on 2023/07/04.
//

import Foundation

protocol SearchAppUseCase {
    @discardableResult
    func searchApp(
        with id: Int,
        completion: @escaping (Result<App, DataTransferError>) -> Void
    ) -> URLSessionTask?
    
    @discardableResult
    func searchAppList(
        with keyword: String,
        page: Int,
        pageSize: Int,
        completion: @escaping (Result<AppsPage, DataTransferError>) -> Void
    ) -> URLSessionTask?
}

final class DefaultSearchAppUseCase: SearchAppUseCase {
    private let appRepository: AppRepository
    
    init(appRepository: AppRepository = DefaultAppRepository.shared) {
        self.appRepository = appRepository
    }
    
    func searchApp(
        with id: Int,
        completion: @escaping (Result<App, DataTransferError>) -> Void
    ) -> URLSessionTask? {
        return appRepository.retrieveAppInfo(with: id, completion: completion)
    }
    
    func searchAppList(
        with keyword: String,
        page: Int,
        pageSize: Int,
        completion: @escaping (Result<AppsPage, DataTransferError>) -> Void
    ) -> URLSessionTask? {
        return appRepository.retrieveAppList(with: keyword, page: page, pageSize: pageSize, completion: completion)
    }
}
