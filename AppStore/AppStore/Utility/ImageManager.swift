//
//  ImageManager.swift
//  AppStore
//
//  Created by summercat on 2023/07/05.
//

import Foundation

final class ImageManager {
    static let cache: URLCache = URLCache()
    
    static func retrieveImage(
        with url: String,
        completion: @escaping (Data) -> Void
    ) {
        guard let url = URL(string: url) else { return }
        
        let request: URLRequest = URLRequest(url: url)
        if let data = loadImageFromCache(with: request) {
            completion(data)
        } else {
            downloadImage(with: request) { data in
                completion(data)
            }
        }
    }
    
    private static func loadImageFromCache(with request: URLRequest) -> Data? {
        return cache.cachedResponse(for: request)?.data
    }
    
    private static func downloadImage(
        with request: URLRequest,
        completion: @escaping (Data) -> Void
    ) {
        let task = URLSession.shared.dataTask(with: request) { data, response, _ in
            guard let data = data,
                  let response = response as? HTTPURLResponse,
                  (200..<300) ~= response.statusCode else { return }
            
            let cachedResponse: CachedURLResponse = CachedURLResponse(response: response, data: data)
            cache.storeCachedResponse(cachedResponse, for: request)
            
            completion(data)
        }
        task.resume()
    }
}
