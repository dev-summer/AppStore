//
//  TodayViewModelTests.swift
//  AppStoreTests
//
//  Created by summercat on 2023/07/05.
//

@testable import AppStore
import XCTest

final class TodayViewModelTests: XCTestCase {
    private let app: App = App(
        appID: Int.zero,
        appName: String.init(),
        price: Double.zero,
        formattedPrice: String.init(),
        categoryName: .init(),
        appIconURL: String.init(),
        averageUserRating: Double.zero,
        userRatingCount: Int.zero,
        screenshotURLs: Array.init(),
        contentAdvisoryRating: String.init(),
        languageCodesISO2A: Array.init(),
        fileSizeBytes: String.init(),
        description: String.init(),
        releaseNotes: nil,
        version: String.init(),
        categories: Array.init(),
        providerName: String.init(),
        minimumOSVersion: String.init()
    )
    private var sut: TodayViewModel!
    
    func test_fetchAppsSuccess() {
        // given
        let expectation = XCTestExpectation(description: "success")
        let expectedResult: [TodaySection: [TodayItem]] = [.large: [TodayItem(app: app, type: .large)], .list: [TodayItem(app: app, type: .list)]]
        let useCase: MockSuccessSearchAppUseCase = MockSuccessSearchAppUseCase(app: app)
        var callCount: Int = 0
        sut = TodayViewModel(useCase: useCase)
        
        // when
        var output: [TodaySection: [TodayItem]] = [:]
        sut.appsDelivered = { apps in
            output = apps
            callCount += 1
            
            if callCount == 2 {
                // then
                XCTAssertEqual(output, expectedResult)
                useCase.verify()
                expectation.fulfill()
            } else if callCount > 2 {
                XCTFail()
            }
        }
        sut.fetchApps()
        
        wait(for: [expectation], timeout: 1)
    }
}

final class MockSuccessSearchAppUseCase: SearchAppUseCase {
    private var app: App
    private var searchAppCallCount: Int = 0
    private var searchAppListCallCount: Int = 0
    
    init(app: App) {
        self.app = app
    }
    
    func searchApp(with id: Int, completion: @escaping (Result<App, DataTransferError>) -> Void) -> URLSessionTask? {
        searchAppCallCount += 1
        completion(.success(app))
        
        return nil
    }
    
    func searchAppList(with keyword: String, page: Int, pageSize: Int, completion: @escaping (Result<AppsPage, DataTransferError>) -> Void) -> URLSessionTask? {
        let appsPage: AppsPage = AppsPage(count: 1, searchResults: [app])
        searchAppListCallCount += 1
        completion(.success(appsPage))
        
        return nil
    }
    
    func verify() {
        XCTAssertEqual(searchAppCallCount, 1)
        XCTAssertEqual(searchAppListCallCount, 1)
    }
}
