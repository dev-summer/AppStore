//
//  AppListViewModel.swift
//  AppStore
//
//  Created by summercat on 2023/07/10.
//

final class AppListViewModel {
    private enum Query {
        static let page: Int = .zero
        static let pageSize: Int = 20
    }
    
    var description: String?
    var title: String?
    var appsDelivered: (([TodayItem]) -> Void)?
    var errorDelivered: ((String) -> Void)?
    var cellTapped: ((DetailViewModel) -> Void)?
    private let useCase: SearchAppUseCase
    private let keyword: String
    
    init(keyword: String, title: String, description: String, useCase: SearchAppUseCase = DefaultSearchAppUseCase()) {
        self.keyword = keyword
        self.title = title
        self.description = description
        self.useCase = useCase
    }
    
    func fetchAppList() {
        useCase.searchAppList(with: keyword, page: Query.page, pageSize: Query.pageSize) { [weak self] result in
            switch result {
            case .success(let appsPage):
                let items: [TodayItem] = appsPage.searchResults.compactMap { TodayItem(app: $0, type: .list) }
                self?.appsDelivered?(items)
            case .failure(let error):
                self?.errorDelivered?(error.localizedDescription)
            }
        }
    }
    
    func didTapCell(with item: TodayItem) {
        cellTapped?(item.appID)
    }
}
