//
//  AppListViewModelTests.swift
//  AppStoreTests
//
//  Created by summercat on 2023/11/11.
//

@testable import AppStore
import XCTest

final class AppListViewModelTests: XCTestCase {
    private let app: App = App(
        appID: Int.zero,
        appName: String.init(),
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
    private var sut: AppListViewModel!
    
    func test_fetchAppListSuccess() {
        // given
        let expectation = XCTestExpectation(description: "success")
        let expectedResult: [TodayItem] = [TodayItem(app: app, type: .list)]
        let useCase = MockSuccessSearchAppUseCase(app: app)
        var callCount: Int = 0
        sut = AppListViewModel(title: "test", description: "test", keyword: "test", useCase: useCase)
        
        // when
        var output: [TodayItem] = []
        sut.appsDelivered = { apps in
            output = apps
            callCount += 1
            
            if callCount == 1 {
                // then
                XCTAssertEqual(output, expectedResult)
                useCase.verify(searchAppListCallCount: 1)
                expectation.fulfill()
            } else {
                XCTFail()
            }
        }
        sut.fetchAppList()
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_fetchAppListFailiure() {
        // given
        let expectation = XCTestExpectation(description: "failure")
        let expectedResult = DataTransferError.decodingFailure.errorDescription
        let useCase = MockFailureSearchAppUseCase(error: .decodingFailure)
        var callCount: Int = 0
        sut = AppListViewModel(title: "test", description: "test", keyword: "test", useCase: useCase)
        
        // when
        var output: String? = nil
        sut.errorDelivered = { errorDescription in
            output = errorDescription
            callCount += 1
            
            if callCount == 1 {
                // then
                XCTAssertEqual(output, expectedResult)
                useCase.verify(searchAppListCallCount: 1)
                expectation.fulfill()
            } else {
                XCTFail()
            }
        }
        sut.fetchAppList()
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_cellTapSuccess() {
        // given
        let expectation = XCTestExpectation(description: "success")
        let expectedResult = app
        let item = TodayItem(app: app, type: .list)
        let useCase = MockSuccessSearchAppUseCase(app: app)
        var callCount: Int = 0
        sut = AppListViewModel(title: "test", description: "test", keyword: "test", useCase: useCase)
        
        // when
        var output: App? = nil
        sut.showDetail = { app in
            output = app
            callCount += 1
            
            if callCount == 1 {
                // then
                XCTAssertEqual(output, expectedResult)
                useCase.verify(searchAppCallCount: 1)
                expectation.fulfill()
            } else {
                XCTFail()
            }
        }
        sut.didTapCell(with: item)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_cellTapFailiure() {
        // given
        let expectation = XCTestExpectation(description: "failure")
        let expectedResult = DataTransferError.decodingFailure.errorDescription
        let item = TodayItem(app: app, type: .list)
        let useCase = MockFailureSearchAppUseCase(error: .decodingFailure)
        var callCount: Int = 0
        sut = AppListViewModel(title: "test", description: "test", keyword: "test", useCase: useCase)
        
        // when
        var output: String? = nil
        sut.errorDelivered = { errorDescription in
            output = errorDescription
            callCount += 1
            
            if callCount == 1 {
                // then
                XCTAssertEqual(output, expectedResult)
                useCase.verify(searchAppListCallCount: 1)
                expectation.fulfill()
            } else {
                XCTFail()
            }
        }
        sut.didTapCell(with: item)
        
        wait(for: [expectation], timeout: 1)
    }
}
