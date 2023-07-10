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
    
    let item: TodayItem
    var price: String {
        return item.price == .zero ? Namespace.free : item.formattedPrice
    }
    var imageDataDelivered: ((Data) -> Void)?
    
    init(item: TodayItem) {
        self.item = item
    }
    
    func fetchIconImage() {
         ImageManager.retrieveImage(with: item.appIconURL, completion: { [weak self] data in
             self?.imageDataDelivered?(data)
        })
    }
}
