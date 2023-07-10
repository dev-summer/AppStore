//
//  TodayViewModel.swift
//  AppStore
//
//  Created by summercat on 2023/07/03.
//

final class TodayViewModel {
    private enum Query {
        static let exampleID: Int = 544007664
        static let exampleKeyword: String = "캘린더"
        static let page: Int = .zero
        static let pageSize: Int = 5
    }
    
    var appsDelivered: (([Section: [TodayItem]]) -> Void)?
    var errorDelivered: ((String) -> Void)?
    var largeSectionTapped: ((DetailViewModel) -> Void)?
    var listSectionTapped: ((AppListViewModel) -> Void)?
    private let useCase: SearchAppUseCase
    private var apps: [Section: [TodayItem]] = [:] {
        didSet {
            appsDelivered?(apps)
        }
    }
    
    init(useCase: SearchAppUseCase = DefaultSearchAppUseCase()) {
        self.useCase = useCase
        Section.allCases.forEach { apps[$0] = [] }
    }
    
    func fetchApps() {
        searchAppInfo(with: Query.exampleID)
        searchAppList(with: Query.exampleKeyword, page: Query.page, pageSize: Query.pageSize)
    }
    
    func didTapCellAt(section: Section, with item: TodayItem) {
        switch section {
        case .large:
            largeSectionTapped?(DetailViewModel(appID: item.appID))
        case .list:
            listSectionTapped?(AppListViewModel(keyword: Query.exampleKeyword))
        }
    }
    
    private func searchAppInfo(with id: Int) {
        useCase.searchApp(with: id) { [weak self] result in
            switch result {
            case .success(let app):
                let item = TodayItem(app: app, type: .large)
                self?.apps[item.type]?.append(item)
            case .failure(let error):
                self?.errorDelivered?(error.localizedDescription)
            }
        }
    }
    
    private func searchAppList(with keyword: String, page: Int, pageSize: Int) {
        useCase.searchAppList(with: keyword, page: page, pageSize: pageSize) { [weak self] result in
            switch result {
            case .success(let appsPage):
                let items: [TodayItem] = appsPage.searchResults.compactMap { TodayItem(app: $0, type: .list) }
                self?.apps[.list]?.append(contentsOf: items)
            case .failure(let error):
                self?.errorDelivered?(error.localizedDescription)
            }
        }
    }
}
