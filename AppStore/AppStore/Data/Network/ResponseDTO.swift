//
//  ResponseDTO.swift
//  AppStore
//
//  Created by summercat on 2023/07/03.
//

import Foundation

struct ResponseDTO: Decodable {
    let resultCount: Int
    let results: [AppResponse]
}

struct AppResponse: Decodable {
    let appID: Int
    let appName: String
    let price: Double
    let formattedPrice: String
    let categoryName: String
    let appIconURL: String
    let averageUserRating: Double
    let userRatingCount: Int
    let screenshotURLs: [String]
    let contentAdvisoryRating: String
    let languageCodesISO2A: [String]
    let fileSizeBytes: String
    let description: String
    let releaseNotes: String?
    let version: String
    let categories: [String]
    let providerName: String
    let minimumOSVersion: String
    
    private enum CodingKeys: String, CodingKey {
        case appID = "trackId"
        case appName
        case price
        case formattedPrice
        case categoryName
        case appIconURL = "artworkUrl512"
        case averageUserRating
        case userRatingCount
        case screenshotURLs = "screenshotUrls"
        case contentAdvisoryRating
        case languageCodesISO2A
        case fileSizeBytes
        case description
        case releaseNotes
        case version
        case categories = "genres"
        case providerName = "sellerName"
        case minimumOSVersion = "minimumOsVersion"
    }
}
