//
//  RequestService.swift
//  AppStore
//
//  Created by summercat on 2023/07/03.
//

import Foundation

protocol RequestService {
    func request(
        _ request: URLRequest,
        completion: @escaping (Data?, URLResponse?, Error?) -> Void
    ) -> URLSessionTask
}

final class DefaultRequestService: RequestService {
    func request(_ request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionTask {
        return URLSession.shared.dataTask(with: request, completionHandler: completion)
    }
}
