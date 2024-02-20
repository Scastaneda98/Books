//
//  LandingViewModelTest.swift
//  BooksTests
//
//  Created by Santiago Castaneda on 20/02/24.
//

import XCTest
@testable import Books

final class LandingViewModelTest: XCTestCase {
    var landingViewModel: LandingViewModel!
    
    override func setUpWithError() throws {
        landingViewModel = LandingViewModel()
    }
    
    override func tearDownWithError() throws {
        landingViewModel = nil
    }
    
    func testGetAllBooksSuccess() {
        // Arrange
        let expectation = XCTestExpectation(description: "Fetching all books should complete successfully")
        
        // Act
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            expectation.fulfill()
        }
        
        // Assert
        wait(for: [expectation], timeout: 5.0)
        XCTAssertGreaterThan(landingViewModel.books.count, 0)
    }
    
}
