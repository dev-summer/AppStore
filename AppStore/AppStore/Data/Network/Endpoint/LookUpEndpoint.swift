//
//  LookUpEndpoint.swift
//  AppStore
//
//  Created by summercat on 2023/07/03.
//

struct LookUpEndpoint: AppStoreAPIEndpoint {
    typealias Response = ResponseDTO
    
    let httpMethod: HTTPMethod = .get
    let path: String = "/lookup"
    let parameters: [String: String]
    let id: Int
    
    init(id: Int) {
        self.id = id
        self.parameters = [
            "country": "kr",
            "id": String(id)
        ]
    }
}
