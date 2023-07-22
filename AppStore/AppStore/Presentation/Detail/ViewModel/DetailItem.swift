////
////  DetailItem.swift
////  AppStore
////
////  Created by summercat on 2023/07/12.
////

import Foundation
import UIKit

enum DetailSection: Int, Hashable, CaseIterable {
    case top
    case summary
    case screenshot
    case description
//    case rating
    case releaseNote
    case information
}

extension DetailSection {
    func isValid(for app: App) -> Bool {
        switch self {
        case .releaseNote:
            return app.releaseNotes != nil && app.releaseNotes != .init()
        default:
            return true
        }
    }
}

enum DetailItem: Hashable {
    case top(DetailTopItemModel)
    case summary(DetailSummaryItemModel)
    case screenshot(DetailScreenshotItemModel)
    case description(DetailDescriptionItemModel)
//    case rating
    case releaseNote(DetailReleaseNotesItemModel)
    case information(DetailInformationItemModel)
}

final class DetailTopItemModel {
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

extension DetailTopItemModel: Hashable {
    static func == (lhs: DetailTopItemModel, rhs: DetailTopItemModel) -> Bool {
        return lhs.appName == rhs.appName
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(appName)
        hasher.combine(appName)
    }
}

enum DetailSummaryItemType {
    case ratings
    case age
    case developer
    case language
}

struct DetailSummaryItemModel {
    let topLabelText: String?
    let middleLabelText: String?
    let bottomLabelText: String?
    let type: DetailSummaryItemType
}

extension DetailSummaryItemModel: Hashable { }

final class DetailScreenshotItemModel {
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

extension DetailScreenshotItemModel: Hashable {
    static func == (lhs: DetailScreenshotItemModel, rhs: DetailScreenshotItemModel) -> Bool {
        return lhs.screenshotURL == rhs.screenshotURL
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(screenshotURL)
    }
}

struct DetailDescriptionItemModel {
    let description: String
}

extension DetailDescriptionItemModel: Hashable { }

struct DetailReleaseNotesItemModel {
    let currentVersion: String
    let releaseNotes: String
}

extension DetailReleaseNotesItemModel: Hashable { }

struct DetailInformationItemModel {
    let itemName: String
    let itemInformation: String
}

extension DetailInformationItemModel: Hashable { }
