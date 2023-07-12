//
//  SearchEndpoint.swift
//  AppStore
//
//  Created by summercat on 2023/07/03.
//

struct SearchEndpoint: AppStoreAPIEndpoint {
    typealias Response = ResponseDTO
    
    let httpMethod: HTTPMethod = .get
    let path: String = "/search"
    let parameters: [String: String]
    let term: String
    let offset: Int
    let limit: Int
    
    init(with requestDTO: SearchRequestDTO) {
        self.term = requestDTO.term
        self.offset = requestDTO.offset
        self.limit = requestDTO.limit
        self.parameters = [
            "country": "kr",
            "media": "software",
            "term": term,
            "offset": String(offset),
            "limit": String(limit)
        ]
    }
}
