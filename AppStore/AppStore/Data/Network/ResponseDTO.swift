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
    let appIconURL: String
    let appCategory: String
    let price: Double
    let formattedPrice: String
    let userRatingCount: Int
    let averageUserRating: Double
    let screenshotURLs: [String]
    let contentAdvisoryRating: String
    let languageCodesISO2A: [String]
    let fileSizeBytes: String
    let description: String
    let releaseNotes: String?
    let version: String
    let providerName: String
    let developerName: String
    let minimumOSVersion: String
    
    private enum CodingKeys: String, CodingKey {
        case appID = "trackId"
        case appName = "trackName"
        case appIconURL = "artworkUrl100"
        case appCategory = "primaryGenreName"
        case price
        case formattedPrice
        case userRatingCount
        case averageUserRating
        case screenshotURLs = "screenshotUrls"
        case contentAdvisoryRating
        case languageCodesISO2A
        case fileSizeBytes
        case description
        case releaseNotes
        case version
        case providerName = "sellerName"
        case developerName = "artistName"
        case minimumOSVersion = "minimumOsVersion"
    }
}

// MARK: Mapping to Domain

extension ResponseDTO {
    func toAppsPage() -> AppsPage {
        return AppsPage(
            count: resultCount,
            searchResults: results.compactMap { $0.toApp() }
        )
    }
}

extension AppResponse {
    func toApp() -> App {
        return App(
            appID: self.appID,
            appName: self.appName,
            appIconURL: self.appIconURL,
            appCategory: self.appCategory,
            price: self.price,
            formattedPrice: self.formattedPrice,
            userRatingCount: self.userRatingCount,
            averageUserRating: self.averageUserRating,
            screenshotURLs: self.screenshotURLs,
            contentAdvisoryRating: self.contentAdvisoryRating,
            languageCodesISO2A: self.languageCodesISO2A,
            fileSizeBytes: self.fileSizeBytes,
            description: self.description,
            releaseNotes: self.releaseNotes,
            version: self.version,
            providerName: self.providerName,
            developerName: self.developerName,
            minimumOSVersion: self.minimumOSVersion
        )
    }
}
