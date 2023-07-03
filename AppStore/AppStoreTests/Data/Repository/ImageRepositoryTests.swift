//
//  ImageRepositoryTests.swift
//  AppStoreTests
//
//  Created by summercat on 2023/07/04.
//

@testable import AppStore
import XCTest

final class ImageRepositoryTests: XCTestCase {
    private var sut: ImageRepository!
    
    func test_retrieveImageFromCacheSuccess() {
        // given
        let expectation = XCTestExpectation(description: "success")
        let url: String = "image"
        let imageData: Data = .init()
        let dataTransferService: MockSuccessDataTransferService = MockSuccessDataTransferService()
        let cache: CacheStorage<Data> = CacheStorage<Data>()
        cache.store(imageData, for: url)
        sut = DefaultImageRepository(dataTransferService: dataTransferService, cache: cache)
        
        // when
        _ = sut.retrieveImage(with: url) { result in
            // then
            switch result {
            case .success(let data):
                XCTAssertEqual(imageData, data)
                dataTransferService.verify()
                expectation.fulfill()
            case .failure:
                XCTFail()
            }
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_retrieveImageFromNetworkSuccess() {
        // given
        let expectation = XCTestExpectation(description: "success")
        let url: String = "image"
        let imageData: Data = .init()
        let dataTransferService: MockSuccessDataTransferService = MockSuccessDataTransferService(data: imageData)
        let cache: CacheStorage<Data> = CacheStorage<Data>()
        sut = DefaultImageRepository(dataTransferService: dataTransferService, cache: cache)
        
        // when
        _ = sut.retrieveImage(with: url) { result in
            // then
            switch result {
            case .success(let data):
                XCTAssertEqual(imageData, data)
                XCTAssertTrue(cache.isCached(url))
                dataTransferService.verify(requestCallCount: 1)
                expectation.fulfill()
            case .failure:
                XCTFail()
            }
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_retrieveImageFromNetworkFailure() {
        // given
        let expectation = XCTestExpectation(description: "failure")
        let url: String = "image"
        let dataTransferService: MockFailureDataTransferService = MockFailureDataTransferService(error: .decodingFailure)
        let cache: CacheStorage<Data> = CacheStorage<Data>()
        sut = DefaultImageRepository(dataTransferService: dataTransferService, cache: cache)
        
        // when
        _ = sut.retrieveImage(with: url, completion: { result in
            // then
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(.decodingFailure, error)
                XCTAssertFalse(cache.isCached(url))
                dataTransferService.verify(requestCallCount: 1)
                expectation.fulfill()
            }
        })
        
        wait(for: [expectation], timeout: 1)
    }
}
