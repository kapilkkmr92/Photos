//
//  SearchPhotosTests.swift
//  SearchPhotosTests
//
//  Created by Kapil.kumar on 17/05/20.
//  Copyright © 2020 Kapil.kumar. All rights reserved.
//

import XCTest
@testable import SearchPhotos

class SearchPhotosTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGetImagesSuccessReturnsImages() {
        let requestManager = RequestManager<ImagesResponse>()
        let query = "cat"
        let imagesExpectation = expectation(description: "images")
        requestManager.getImagesWith(query: query) { (result) in
            
            switch result {
            case .success:
                imagesExpectation.fulfill()
            case .failed(let error,_):
                print(error)
            }
        }
        waitForExpectations(timeout: 3) { (error) in
            XCTAssertNotNil(imagesExpectation)
        }
    }
    
    func testImagesApiWhenNoDataReturns() {
        let requestManager = RequestManager<ImagesResponse>()
        let query = "kapil"
        let errorExpectation = expectation(description: "No data")
        requestManager.getImagesWith(query: query) { (result) in
            
            switch result {
            case .success(let images):
                if images?.imageItems.count == 0 {
                    errorExpectation.fulfill()
                }
            case .failed(let _,_):
                break
            }
        }
        waitForExpectations(timeout: 3) { (error) in
            XCTAssertNotNil(errorExpectation)
        }
    }
    
}
