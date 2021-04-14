//
//  SearchTrainViewControllerTest.swift
//  MyTravelHelperTests
//
//  Created by ShailAadi on 13/4/21.
//  Copyright © 2021 Sample. All rights reserved.
//

import XCTest
import UIKit
@testable import MyTravelHelper

class SearchTrainViewControllerTest: XCTestCase {
    
    private var storyboard: UIStoryboard!
    private var sut: SearchTrainViewController!
    private var searchTrainPresenter: SearchTrainPresenter!
    private var mocksut: MockSearchTrainViewController!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = storyboard.instantiateViewController(withIdentifier: "searchTrain") as? SearchTrainViewController
        sut.loadViewIfNeeded()
        
        searchTrainPresenter = SearchTrainPresenter()
        mocksut = MockSearchTrainViewController()
        searchTrainPresenter.view = mocksut
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        storyboard = nil
        sut = nil
        mocksut = nil
        searchTrainPresenter = nil
    }

    func testSearchTrainViewController_WhenCreated_HasRequiredTextFieldsEmpty() throws {
        // Arrange
        let destinationTextField = try XCTUnwrap(sut.destinationTextField, "The destinationTextField is not connected to an IBOutlet")
        let sourceTxtField = try XCTUnwrap(sut.sourceTxtField, "The sourceTxtField is not connected to an IBOutlet")
        let trainsListTable = try XCTUnwrap(sut.trainsListTable, "The trainsListTable is not connected to an IBOutlet")
        
        XCTAssertEqual(sourceTxtField.text, "", "Source text field was not empty when the view controller initially loaded")
        XCTAssertEqual(destinationTextField.text, "", "Destination text field was not empty when the view controller initially loaded")
        XCTAssertTrue(trainsListTable.numberOfRows(inSection: 0) == 0, "Table view rows should be zero")
    }
    
    func testSearchTrainViewController_WhenCreated_HasSearchButtonAndAction() throws {
        // Arrange
        let searchButton: UIButton = try XCTUnwrap(sut.searchButton, "Search button does not have a referencing outlet")
        
        // Act
        let searchButtonActions = try XCTUnwrap(searchButton.actions(forTarget: sut, forControlEvent: .touchUpInside), "Search button does not have any actions assigned to it")

        // Assert
        XCTAssertEqual(searchButtonActions.count, 1)
        XCTAssertEqual(searchButtonActions.first, "searchTrainsTapped:", "There is no action with a name SearchTrainButtonTapped assigned to SearchTrain button")
    }
    
    func testSearchTrainViewController_WhenSearchButtonTapped_InvokesSearchTrainProcess() {
        // Arrange
        let mockSearchTrainPresenter = SearchTrainPresenterMock()
        sut.presenter = mockSearchTrainPresenter
        
        // Act
        sut.searchButton.sendActions(for: .touchUpInside)
        
        // Assert
        XCTAssertTrue(mockSearchTrainPresenter.isSearchTappedCalled, "The searchTapped() method was not called on a Presenter object when the search button was tapped in a SearchTrainViewController")
    }

    func testSearchTrainViewController_WhenFailedToFetchAllStation_ShouldCallShowFailedToFetchAllStaionsMessage() {
        //Act
        searchTrainPresenter.failedToFetchAllStaions()

        // Assert
        XCTAssertTrue(sut.stationsList.count == 0, "stationsList count should be zero")
        XCTAssertTrue(mocksut.isShowFailedToFetchAllStaionsMessageCalled)
    }

    func testSearchTrainViewController_WhenNoNetworkAvailable_ShouldCallShowNoInternetAvailabilityMessage() {
        //Act
        searchTrainPresenter.showNoInternetAvailabilityMessage()

        // Assert
        XCTAssertTrue(mocksut.isShowNoInternetAvailabilityMessageCalled)
    }

    func testSearchTrainViewController_WhenFailedToFetchAllStation_ShouldCallShowNoTrainAvailbilityFromSource() {
        //Act
        searchTrainPresenter.showNoTrainAvailbilityFromSource()

        // Assert
        XCTAssertTrue(mocksut.isShowNoTrainAvailbilityFromSourceCalled)
    }

    func testSearchTrainViewController_WhenFetchTrainList_ShouldCallUpdateLatestTrainList() {
        // Arrange
        let trainList = TestUtility.allStationsFromSourceCodeBFSTC()?.trainsList ?? []
        //Act
        searchTrainPresenter.fetchedTrainsList(trainsList: trainList)
        
        // Assert
        XCTAssertTrue(mocksut.isUpdateLatestTrainListCalled)
        
    }

    func testSearchTrainViewController_WhenTrainListIsEmpty_ShouldCallShowNoTrainsFoundAlert() {
        //Act
        searchTrainPresenter.fetchedTrainsList(trainsList: nil)

        // Assert
        XCTAssertTrue(mocksut.isShowNoTrainsFoundAlertCalled)
        
    }
    
    func testSearchTrainViewController_WhenInvailidSourceAndDestinationProvided_ShouldCallShowInvalidSourceOrDestinationAlert() {
        // Arrange
        let invalidSource = "ABC"
        let invalidDestination = "XYZ"
        
        //Act
        searchTrainPresenter.searchTapped(source: invalidSource, destination: invalidDestination)

        // Assert
        XCTAssertTrue(mocksut.isShowInvalidSourceOrDestinationAlertCalled)
        
    }
}

fileprivate class MockSearchTrainViewController: SearchTrainViewController{
    var isShowFailedToFetchAllStaionsMessageCalled = false
    var isShowNoInternetAvailabilityMessageCalled = false
    var isShowNoTrainAvailbilityFromSourceCalled = false
    var isUpdateLatestTrainListCalled = false
    var isShowNoTrainsFoundAlertCalled = false
    var isShowInvalidSourceOrDestinationAlertCalled = false
    
    override func showFailedToFetchAllStaionsMessage() {
        isShowFailedToFetchAllStaionsMessageCalled = true
    }

    override func showNoInternetAvailabilityMessage() {
        isShowNoInternetAvailabilityMessageCalled = true
    }

    override func showNoTrainAvailbilityFromSource() {
        isShowNoTrainAvailbilityFromSourceCalled = true
    }

    override func updateLatestTrainList(trainsList: [StationTrain]) {
        isUpdateLatestTrainListCalled = true
    }

    override func showNoTrainsFoundAlert() {
        isShowNoTrainsFoundAlertCalled = true
    }

    override func showInvalidSourceOrDestinationAlert() {
        isShowInvalidSourceOrDestinationAlertCalled = true
    }
}
