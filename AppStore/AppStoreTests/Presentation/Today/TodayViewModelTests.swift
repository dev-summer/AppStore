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
    private var sut: TodayViewModel!
    
    func test_fetchAppsSuccess() {
        // given
        let expectation = XCTestExpectation(description: "success")
        let expectedResult: [TodaySection: [TodayItem]] = [
            .large: [TodayItem(app: app, type: .large)],
            .list: [TodayItem(app: app, type: .list)]
        ]
        let useCase = MockSuccessSearchAppUseCase(app: app)
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
                useCase.verify(searchAppCallCount: 1, searchAppListCallCount: 1)
                expectation.fulfill()
            } else if callCount > 2 {
                XCTFail()
            }
        }
        sut.fetchApps()
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_fetchAppsFailure() {
        // given
        let expectation = XCTestExpectation(description: "success")
        let expectedResult = DataTransferError.decodingFailure.errorDescription
        let useCase = MockFailureSearchAppUseCase(error: .decodingFailure)
        var callCount: Int = 0
        sut = TodayViewModel(useCase: useCase)
        
        // when
        var output: String? = nil
        sut.errorDelivered = { errorDescription in
            output = errorDescription
            callCount += 1
            
            if callCount == 2 {
                // then
                XCTAssertEqual(output, expectedResult)
                useCase.verify(searchAppCallCount: 1, searchAppListCallCount: 1)
                expectation.fulfill()
            } else if callCount > 2 {
                XCTFail()
            }
        }
        sut.fetchApps()
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_largeCellTapSuccess() {
        // given
        let expectation = XCTestExpectation(description: "success")
        let expectedResult: App = app
        let useCase = MockSuccessSearchAppUseCase(app: app)
        var callCount: Int = 0
        let item = TodayItem(app: app, type: .large)
        sut = TodayViewModel(useCase: useCase)
        
        // when
        var output: App? = nil
        sut.showAppDetail = { app in
            output = app
            callCount += 1
            
            // then
            if callCount == 1 {
                XCTAssertEqual(output, expectedResult)
                useCase.verify(searchAppCallCount: 1)
                expectation.fulfill()
            } else {
                XCTFail()
            }
        }
        sut.didTapCellAt(section: item.type, with: item)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_largeCellTapFailure() {
        // given
        let expectation = XCTestExpectation(description: "failure")
        let expectedResult = DataTransferError.decodingFailure.errorDescription
        let useCase = MockFailureSearchAppUseCase(error: .decodingFailure)
        var callCount: Int = 0
        let item = TodayItem(app: app, type: .large)
        sut = TodayViewModel(useCase: useCase)
        
        // when
        var output: String? = nil
        sut.errorDelivered = { errorDescription in
            output = errorDescription
            callCount += 1
            
            // then
            if callCount == 1 {
                XCTAssertEqual(output, expectedResult)
                useCase.verify(searchAppCallCount: 1)
                expectation.fulfill()
            } else {
                XCTFail()
            }
        }
        sut.didTapCellAt(section: item.type, with: item)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_listCellTapSuccess() {
        // given
        let expectation = XCTestExpectation(description: "success")
        let expectedResult = "캘린더"
        let useCase: MockSuccessSearchAppUseCase = MockSuccessSearchAppUseCase(app: app)
        var callCount: Int = 0
        let item = TodayItem(app: app, type: .list)
        sut = TodayViewModel(useCase: useCase)
        
        // when
        var output = ""
        sut.showAppList = { keyword in
            output = keyword
            callCount += 1
            
            // then
            if callCount == 1 {
                XCTAssertEqual(output, expectedResult)
                useCase.verify(searchAppListCallCount: 1)
                expectation.fulfill()
            } else {
                XCTFail()
            }
        }
        sut.didTapCellAt(section: item.type, with: item)
        
        wait(for: [expectation], timeout: 1)
    }
}
