//
//  AppInfoViewModel.swift
//  AppStore
//
//  Created by summercat on 2023/07/07.
//

import Foundation

final class AppInfoViewModel {
    private enum Namespace {
        static let free: String = "GET"
    }
    
    let appName: String
    let appIconURL: String
    let appCategory: String
    let price: String
    var imageDataDelivered: ((Data) -> Void)?
    
    init(item: TodayItem) {
        self.appName = item.appName
        self.appIconURL = item.appIconURL
        self.appCategory = item.appCategory
        self.price = item.price == .zero ? Namespace.free : item.formattedPrice
    }
    
    func fetchIconImage() {
         ImageManager.retrieveImage(with: appIconURL, completion: { [weak self] data in
             self?.imageDataDelivered?(data)
        })
    }
}
