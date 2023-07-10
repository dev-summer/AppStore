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
    
    init(useCase: SearchAppUseCase = DefaultSearchAppUseCase(), appID: Int) {
        self.useCase = useCase
        self.appID = appID
    }
}
