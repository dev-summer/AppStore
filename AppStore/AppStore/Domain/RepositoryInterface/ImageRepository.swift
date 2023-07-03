//
//  ImageRepository.swift
//  AppStore
//
//  Created by summercat on 2023/07/04.
//

import Foundation

protocol ImageRepository {
    func retrieveImage(
        with url: String,
        completion: @escaping (Result<Data, DataTransferError>) -> Void
    ) -> URLSessionTask?
}
