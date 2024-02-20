//
//  LoginViewModelTest.swift
//  BooksTests
//
//  Created by Santiago Castaneda on 20/02/24.
//

import XCTest
@testable import Books

final class LoginViewModelTest: XCTestCase {
    var loginViewModel: LoginViewModel!
    
    override func setUpWithError() throws {
        loginViewModel = LoginViewModel()
    }
    
    override func tearDownWithError() throws {
        loginViewModel = nil
    }
    
    func testLoginWithValidCredentials() {
        // Arrange
        let email = "android.developer@timetonic.com"
        let password = "ios.developer1"
        
        // Act
        loginViewModel.login(email: email, password: password)
        
        // Assert
        XCTAssertEqual(loginViewModel.auth, .Loading)
    }
    
    func testLoginWithInvalidEmail() {
        // Arrange
        let email = ""
        let password = "Android.developer1"
        
        // Act
        loginViewModel.login(email: email, password: password)
        
        // Assert
        XCTAssertTrue(loginViewModel.isInvalidForm)
    }
    
    func testLoginWithInvalidPassword() {
        // Arrange
        let email = "android.developer@timetonic.com"
        let password = ""
        
        // Act
        loginViewModel.login(email: email, password: password)
        
        // Assert
        XCTAssertTrue(loginViewModel.isInvalidForm)
    }
    
    func testLoginWithInvalidEmailAndPassword() {
        // Arrange
        let email = "ios.developer"
        let password = ""
        
        // Act
        loginViewModel.login(email: email, password: password)
        
        // Assert
        XCTAssertTrue(loginViewModel.isInvalidForm)
    }
    
    func testFetchAppKeyValidCredentials() {
        // Arrange
        let email = "android.developer@timetonic.com"
        let password = "Android.developer1"
        let expectation = XCTestExpectation(description: "API request should complete")
        
        // Act
        loginViewModel.login(email: email, password: password)
        
        // Assert
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { [self] in
            XCTAssertEqual(loginViewModel.auth, .Success)
            XCTAssertFalse(loginViewModel.isInvalidForm)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testFetchAppKeyInvalidCredentials() {
        // Arrange
        let email = "ios.developer@timetonic.com"
        let password = "ios.developer1"
        let expectation = XCTestExpectation(description: "API request should complete")
        
        // Act
        loginViewModel.login(email: email, password: password)
        
        // Assert
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { [self] in
            XCTAssertEqual(loginViewModel.auth, .Error)
            XCTAssertTrue(loginViewModel.isInvalidForm)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
}
