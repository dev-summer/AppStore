//
//  DetailViewModel.swift
//  AppStore
//
//  Created by summercat on 2023/07/10.
//

import Foundation

final class DetailViewModel {
    private let appID: Int
    private let useCase: SearchAppUseCase
    
    init(appID: Int, useCase: SearchAppUseCase = DefaultSearchAppUseCase()) {
        self.appID = appID
        self.useCase = useCase
    }
}
