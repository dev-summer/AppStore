//
//  DetailViewModel.swift
//  AppStore
//
//  Created by summercat on 2023/07/10.
//

import Foundation

final class DetailViewModel {
    private let useCase: SearchAppUseCase
    private let appID: Int
    
    init(appID: Int, useCase: SearchAppUseCase = DefaultSearchAppUseCase()) {
        self.appID = appID
        self.useCase = useCase
    }
}
