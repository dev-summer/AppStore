//
//  TodayItem.swift
//  AppStore
//
//  Created by summercat on 2023/07/03.
//

struct TodayItem: Hashable {
    let appID: Int
    let appName: String
    let appIconURL: String
    let appCategory: String
    let price: Double
    let formattedPrice: String
    let type: TodaySection
    
    init(app: App, type: TodaySection) {
        self.appID = app.appID
        self.appName = app.appName
        self.appIconURL = app.appIconURL
        self.appCategory = app.appCategory
        self.price = app.price
        self.formattedPrice = app.formattedPrice
        self.type = type
    }
}
