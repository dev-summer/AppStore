//
//  TodayItem.swift
//  AppStore
//
//  Created by summercat on 2023/07/03.
//

struct TodayItem: Hashable {
    let appID: Int
    let appName: String
    let price: Double
    let formattedPrice: String
    let categoryName: String
    let appIconURL: String
    let type: Section
    
    init(app: App, type: Section) {
        self.appID = app.appID
        self.appName = app.appName
        self.price = app.price
        self.formattedPrice = app.formattedPrice
        self.categoryName = app.categoryName
        self.appIconURL = app.appIconURL
        self.type = type
    }
}
