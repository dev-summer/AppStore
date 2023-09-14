//
//  SearchAppUseCaseTests.swift
//  AppStoreTests
//
//  Created by summercat on 2023/07/04.
//

@testable import AppStore
import XCTest

final class SearchAppUseCaseTests: XCTestCase {
    let app = App(
        appID: Int.zero,
        appName: "app",
        appIconURL: String.init(),
        appCategory: String.init(),
        price: Double.zero,
        formattedPrice: String.init(),
        userRatingCount: Double.zero,
        averageUserRating: Double.zero,
        screenshotURLs: Array.init(),
        contentAdvisoryRating: String.init(),
        languageCodesISO2A: Array.init(),
        fileSizeBytes: String.init(),
        description: String.init(),
        releaseNotes: nil,
        version: String.init(),
        providerName: String.init(),
        developerName: String.init(),
        minimumOSVersion: String.init()
    )
    private var sut: SearchAppUseCase!
    
    func test_searchAppSuccess() {
        // given
        let expectation = XCTestExpectation(description: "success")
        let id: Int = .zero
        let repository = MockSuccessAppRepository(app: app)
        sut = DefaultSearchAppUseCase(appRepository: repository)
        
        // when
        sut.searchApp(with: id) { result in
            // then
            switch result {
            case .success:
                repository.verify(id: id, retrieveAppCallCount: 1)
                expectation.fulfill()
            case .failure:
                XCTFail()
            }
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_searchAppFailure() {
        // given
        let expectation = XCTestExpectation(description: "failure")
        let id: Int = .zero
        let repository = MockFailureAppRepository(error: .decodingFailure)
        sut = DefaultSearchAppUseCase(appRepository: repository)
        
        // when
        sut.searchApp(with: id) { result in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                repository.verify(id: id, retrieveAppCallCount: 1, error: error)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 1)
    }
    
    func test_searchAppsListSuccess() {
        // given
        let expectation = XCTestExpectation(description: "success")
        let keyword: String = "test"
        let page: Int = .zero
        let pageSize: Int = 1
        let appsPage = AppsPage(count: 1, searchResults: [app])
        let repository = MockSuccessAppRepository(appsPage: appsPage)
        sut = DefaultSearchAppUseCase(appRepository: repository)
        
        // when
        sut.searchAppList(
            with: keyword,
            page: page,
            pageSize: pageSize
        ) { result in
            // then
            switch result {
            case .success:
                repository.verify(keyword: keyword, page: page, pageSize: pageSize, retrieveAppListCallCount: 1)
                expectation.fulfill()
            case .failure:
                XCTFail()
            }
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_searchAppsListFailure() {
        // given
        let expectation = XCTestExpectation(description: "fetch app list with keyword failure")
        let keyword: String = "test"
        let page: Int = .zero
        let pageSize: Int = 1
        let repository = MockFailureAppRepository(error: .decodingFailure)
        sut = DefaultSearchAppUseCase(appRepository: repository)
        
        // when
        sut.searchAppList(
            with: keyword,
            page: page,
            pageSize: pageSize,
            completion: { result in
                // then
                switch result {
                case .success:
                    XCTFail()
                case .failure(let error):
                    repository.verify(keyword: keyword, page: page, pageSize: pageSize, retrieveAppListCallCount: 1, error: error)
                    expectation.fulfill()
                }
            })
        
        wait(for: [expectation], timeout: 1)
    }
}
