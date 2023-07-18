//
//  App.swift
//  AppStore
//
//  Created by summercat on 2023/07/03.
//

struct App {
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
}
