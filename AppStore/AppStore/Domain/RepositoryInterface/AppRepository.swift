//
//  AppRepository.swift
//  AppStore
//
//  Created by summercat on 2023/07/03.
//

import Foundation

protocol AppRepository {
    func retrieveAppInfo(
        with id: Int,
        completion: @escaping (Result<App, DataTransferError>) -> Void
    ) -> URLSessionTask?
    
    func retrieveAppList(
        with keyword: String,
        page: Int,
        pageSize: Int,
        completion: @escaping (Result<AppsPage, DataTransferError>) -> Void
    ) -> URLSessionTask?
}
