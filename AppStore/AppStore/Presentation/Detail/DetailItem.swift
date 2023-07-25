////
////  DetailItem.swift
////  AppStore
////
////  Created by summercat on 2023/07/12.
////

import UIKit

enum DetailItem: Hashable {
    case top(DetailTopItem)
    case summary(DetailSummaryItem)
    case screenshot(DetailScreenshotItem)
    case description(DetailDescriptionItem)
//    case rating
    case releaseNote(DetailReleaseNotesItem)
    case information(DetailInformationItem)
}

// MARK: - Top Item Model

final class DetailTopItem {
    private enum Namespace {
        static let free: String = "GET"
    }

    let appName: String
    let appIconURL: String
    let appCategory: String
    let price: String
    var imageDataDelivered: ((Data) -> Void)?

    init(app: App) {
        self.appName = app.appName
        self.appIconURL = app.appIconURL
        self.appCategory = app.appCategory
        self.price = app.price == .zero ? Namespace.free : app.formattedPrice
    }

    func fetchIconImage() {
         ImageManager.retrieveImage(with: appIconURL, completion: { data in
             self.imageDataDelivered?(data)
        })
    }
}

extension DetailTopItem: Hashable {
    static func == (lhs: DetailTopItem, rhs: DetailTopItem) -> Bool {
        return lhs.appName == rhs.appName
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(appName)
        hasher.combine(appName)
    }
}

// MARK: - Summary Item Model

enum DetailSummaryItemType {
    case ratings
    case age
    case developer
    case language
}

struct DetailSummaryItem {
    let topLabelText: String?
    let middleLabelText: String?
    let bottomLabelText: String?
    let type: DetailSummaryItemType
}

extension DetailSummaryItem: Hashable { }

// MARK: - Screenshot Item Model

final class DetailScreenshotItem {
    let screenshotURL: String
    var imageDataDelivered: ((Data) -> Void)?
    
    init(screenshotURL: String) {
        self.screenshotURL = screenshotURL
    }
    
    func fetchScreenshot() {
         ImageManager.retrieveImage(with: screenshotURL, completion: { data in
             self.imageDataDelivered?(data)
        })
    }
}

extension DetailScreenshotItem: Hashable {
    static func == (lhs: DetailScreenshotItem, rhs: DetailScreenshotItem) -> Bool {
        return lhs.screenshotURL == rhs.screenshotURL
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(screenshotURL)
    }
}

// MARK: - Description Item Model

struct DetailDescriptionItem {
    let description: String
}

extension DetailDescriptionItem: Hashable { }

// MARK: - Release Notes Item Model

struct DetailReleaseNotesItem {
    let currentVersion: String
    let releaseNotes: String
}

extension DetailReleaseNotesItem: Hashable { }

// MARK: - Information Item Model

struct DetailInformationItem {
    let itemName: String
    let itemInformation: String
}

extension DetailInformationItem: Hashable { }
