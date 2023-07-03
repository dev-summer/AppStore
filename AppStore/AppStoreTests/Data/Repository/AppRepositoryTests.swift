//
//  AppRepositoryTests.swift
//  AppStoreTests
//
//  Created by summercat on 2023/07/03.
//

@testable import AppStore
import XCTest

final class AppRepositoryTests: XCTestCase {
    private let appResponse: AppResponse = AppResponse(
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
    private var sut: AppRepository!
    
    func test_retrieveAppInfoFromCacheSuccess() {
        // given
        let expectation = XCTestExpectation(description: "success")
        let dataTransferService: MockSuccessDataTransferService = MockSuccessDataTransferService()
        let cache: CacheStorage<AppResponse> = CacheStorage<AppResponse>()
        cache.store(appResponse, for: appResponse.appID)
        sut = DefaultAppRepository(
            dataTransferService: dataTransferService,
            appResponseCache: cache
        )
        
        // when
        _ = sut.retrieveAppInfo(with: .zero) { result in
            // then
            switch result {
            case .success(let app):
                XCTAssertEqual(self.appResponse.toApp(), app)
                dataTransferService.verify()
                expectation.fulfill()
            case .failure:
                XCTFail()
            }
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_retrieveAppInfoFromNetworkSuccess() {
        // given
        let expectation = XCTestExpectation(description: "success")
        let responseDTO: ResponseDTO = ResponseDTO(resultCount: 1, results: [appResponse])
        let dataTransferService: MockSuccessDataTransferService = MockSuccessDataTransferService(responseDTO: responseDTO)
        let cache: CacheStorage<AppResponse> = CacheStorage<AppResponse>()
        sut = DefaultAppRepository(
            dataTransferService: dataTransferService,
            appResponseCache: cache
        )
        
        // when
        _ = sut.retrieveAppInfo(with: .zero, completion: { result in
            // then
            switch result {
            case .success(let app):
                XCTAssertEqual(app.appID, Int.zero)
                XCTAssertTrue(cache.isCached(Int.zero))
                dataTransferService.verify(requestJSONCallCount: 1)
                expectation.fulfill()
            case .failure:
                XCTFail()
            }
        })
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_retrieveAppInfoFromServerFailure() {
        // given
        let expectation = XCTestExpectation(description: "failure")
        let id: Int = .zero
        let dataTransferService: MockFailureDataTransferService =  MockFailureDataTransferService(error: .decodingFailure)
        let cache: CacheStorage<AppResponse> = CacheStorage<AppResponse>()
        sut = DefaultAppRepository(
            dataTransferService: dataTransferService,
            appResponseCache: cache
        )
        
        // when
        _ = sut.retrieveAppInfo(with: id, completion: { result in
            // then
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error, .decodingFailure)
                XCTAssertFalse(cache.isCached(id))
                dataTransferService.verify(requestJSONCallCount: 1)
                expectation.fulfill()
            }
        })
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_retrieveAppListFromCacheSuccess() {
        // given
        let expectation = XCTestExpectation(description: "success")
        let dataTransferService: MockSuccessDataTransferService = MockSuccessDataTransferService()
        let searchRequestDTO: SearchRequestDTO = SearchRequestDTO(term: "test", offset: Int.zero, limit: 1)
        let responseDTO: ResponseDTO = ResponseDTO(resultCount: 1, results: [appResponse])
        let cache: CacheStorage<ResponseDTO> = CacheStorage<ResponseDTO>()
        cache.store(responseDTO, for: searchRequestDTO)
        sut = DefaultAppRepository(
            dataTransferService: dataTransferService,
            appListCache: cache
        )
        
        // when
        _ = sut.retrieveAppList(
            with: searchRequestDTO.term,
            page: searchRequestDTO.offset,
            pageSize: searchRequestDTO.limit,
            completion: { result in
                // then
                switch result {
                case .success(let appsPage):
                    XCTAssertEqual(responseDTO.toAppsPage(), appsPage)
                    dataTransferService.verify()
                    expectation.fulfill()
                case .failure:
                    XCTFail()
                }
            })
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_retriveAppListFromNetworkSuccess() {
        // given
        let expectation = XCTestExpectation(description: "success")
        let searchRequestDTO: SearchRequestDTO = SearchRequestDTO(term: "test", offset: Int.zero, limit: 1)
        let responseDTO: ResponseDTO = ResponseDTO(resultCount: 1, results: [appResponse])
        let dataTransferService: MockSuccessDataTransferService = MockSuccessDataTransferService(responseDTO: responseDTO)
        let appResponseCache: CacheStorage<AppResponse> = CacheStorage<AppResponse>()
        let appListCache: CacheStorage<ResponseDTO> = CacheStorage<ResponseDTO>()
        sut = DefaultAppRepository(
            dataTransferService: dataTransferService,
            appResponseCache: appResponseCache,
            appListCache: appListCache
        )
        
        // when
        _ = sut.retrieveAppList(
            with: "test",
            page: Int.zero,
            pageSize: 1,
            completion: { result in
                // then
                switch result {
                case .success(let data):
                    XCTAssertEqual(responseDTO.toAppsPage(), data)
                    XCTAssertTrue(appListCache.isCached(searchRequestDTO))
                    XCTAssertTrue(appResponseCache.isCached(self.appResponse.appID))
                    dataTransferService.verify(requestJSONCallCount: 1)
                    expectation.fulfill()
                case .failure:
                    XCTFail()
                }
            })
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_retrieveAppListFromNetworkFailure() {
        // given
        let expectation = XCTestExpectation(description: "failure")
        let dataTransferService: MockFailureDataTransferService =  MockFailureDataTransferService(error: .decodingFailure)
        let searchRequestDTO: SearchRequestDTO = SearchRequestDTO(term: "test", offset: Int.zero, limit: 1)
        let cache: CacheStorage<ResponseDTO> = CacheStorage<ResponseDTO>()
        sut = DefaultAppRepository(
            dataTransferService: dataTransferService,
            appListCache: cache
        )
        
        // when
        _ = sut.retrieveAppList(
            with: searchRequestDTO.term,
            page: searchRequestDTO.offset,
            pageSize: searchRequestDTO.limit,
            completion: { result in
                // then
                switch result {
                case .success:
                    XCTFail()
                case .failure(let error):
                    XCTAssertEqual(.decodingFailure, error)
                    XCTAssertFalse(cache.isCached(searchRequestDTO))
                    dataTransferService.verify(requestJSONCallCount: 1)
                    expectation.fulfill()
                }
            })
        
        wait(for: [expectation], timeout: 1)
    }
}
