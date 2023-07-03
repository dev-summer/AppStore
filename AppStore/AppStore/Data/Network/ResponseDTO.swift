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
    let trackName: String
    let trackID: Int
    let price: Double
    let formattedPrice: String
    let primaryGenreName: String
    let artworkURL512: String
    let averageUserRating: Double
    let userRatingCount: Int
    let screenshotURLs: [String]
    let artistName: String
    let contentAdvisoryRating: String
    let languageCodesISO2A: [String]
    let fileSizeBytes: String
    let description: String
    let releaseNotes: String?
    let version: String
    let genres: [String]
    let sellerName: String
    let minimumOSVersion: String
    
    private enum CodingKeys: String, CodingKey {
        case trackName
        case trackID = "trackId"
        case price
        case formattedPrice
        case primaryGenreName
        case artworkURL512 = "artworkUrl512"
        case averageUserRating
        case userRatingCount
        case screenshotURLs = "screenshotUrls"
        case artistName
        case contentAdvisoryRating
        case languageCodesISO2A
        case fileSizeBytes
        case description
        case releaseNotes
        case version
        case genres
        case sellerName
        case minimumOSVersion = "minimumOsVersion"
    }
}
