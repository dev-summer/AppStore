//
//  SearchRequestDTO.swift
//  AppStore
//
//  Created by summercat on 2023/07/03.
//

struct SearchRequestDTO: Hashable {
    let term: String
    let offset: Int
    let limit: Int
}
