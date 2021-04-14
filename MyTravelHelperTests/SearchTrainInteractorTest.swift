//
//  SearchTrainInteractorTest.swift
//  MyTravelHelperTests
//
//  Created by ShailAadi on 13/4/21.
//  Copyright © 2021 Sample. All rights reserved.
//

import XCTest
@testable import MyTravelHelper

class SearchTrainInteractorTest: XCTestCase {
    
    var sut: MockSearchTrainInteractor!
    var mockWebService: MockWebService!
    var presenter: SearchTrainPresenterMock!
    override func setUp() {
        mockWebService = MockWebService()
        presenter = SearchTrainPresenterMock()
        sut = MockSearchTrainInteractor(webService: mockWebService)
        sut.presenter = presenter
    }

    override func tearDown() {
        mockWebService = nil
        presenter = nil
        sut = nil
    }

    func testTrainInteractor_WhenFetchAllStaion_StationListFetchedMethodShouldCall() {
        // Arrange
        let expectation = self.expectation(description: "Fetch All Stations")
        mockWebService.expectation = expectation
    
        // Act
        sut.fetchallStations()
        
        // Assert
        XCTAssertTrue(presenter.isStationListFetchedCalled, "After fetching all stations stationListFetched(:) should have called")

        self.wait(for: [expectation], timeout: 5.0)
    }

    func testTrainInteractor_WhenFetchToFailAllStaion_FailedToFetchAllStaionsMethodShouldCall() {
        // Arrange
        let expectation = self.expectation(description: "Failed to fetch all stations")
        mockWebService.shouldShowError = true
        mockWebService.expectation = expectation

        // Act
        sut.fetchallStations()
        self.wait(for: [expectation], timeout: 5.0)
        
        // Assert
        XCTAssertTrue(presenter.isFailedToFetchAllStaionsCalled, "After failing to fetch all stations failedToFetchAllStaions() should have called")
    }
    
    func testTrainInteractor_WhenValidSourceAndDetinationProvided_ShouldShowTrainList() {
        // Arrange
        let sourceCode = "BFSTC"
        let destinationCode = "CNLLY"
        let expectation = self.expectation(description: "Fetch trains between source to destination")
        mockWebService.expectation = expectation
        
        // Act
        sut.fetchTrainsFromSource(sourceCode: sourceCode, destinationCode: destinationCode)
        self.wait(for: [expectation], timeout: 5.0)

        //Assert
        XCTAssertTrue(sut.isProceesTrainListforDestinationCheckCalled, "After fetching all trains between source to destination proceesTrainListforDestinationCheck() should have called")
    }
    
    func testTrainInteractor_WhenNoNetworkErrorOccurred_ShowNoInternetAvailableMessage() {
        // Arrange
        let error = WebServicesError.networkNotReachable
        
        // Act
        sut.errorHandler(error: error)
        
        // Assert
        XCTAssertTrue(presenter.isShowNoInternetAvailabilityMessageCalled, "When no network is avialable showNoInternetAvailabilityMessage() should have called")
    }

    func testTrainInteractor_WhenOtherErrorOccurred_ShowNoTrainAvailableMessage() {
        // Arrange
        let error = WebServicesError.invalidResponseModel
        
        // Act
        sut.errorHandler(error: error)
        
        // Assert
        XCTAssertTrue(presenter.isShowNoTrainAvailbilityFromSourceCalled, "When no network is avialable showNoInternetAvailabilityMessage() should have called")
    }
}

class MockSearchTrainInteractor: SearchTrainInteractor {
    var isProceesTrainListforDestinationCheckCalled = false
    override func proceesTrainListforDestinationCheck(trainsList: [StationTrain]) {
        isProceesTrainListforDestinationCheckCalled = true
        super.proceesTrainListforDestinationCheck(trainsList: trainsList)
    }
}
