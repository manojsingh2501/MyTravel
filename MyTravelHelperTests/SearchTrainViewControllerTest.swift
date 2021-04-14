//
//  SearchTrainViewControllerTest.swift
//  MyTravelHelperTests
//
//  Created by ShailAadi on 13/4/21.
//  Copyright © 2021 Sample. All rights reserved.
//

@testable import MyTravelHelper
import XCTest

class SearchTrainViewControllerTest: XCTestCase {
    private var storyboard: UIStoryboard!
    private var sut: SearchTrainViewController!
    private var searchTrainPresenter: SearchTrainPresenter!

    override func setUp() {
        super.setUp()
        storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = storyboard.instantiateViewController(withIdentifier: "searchTrain") as? SearchTrainViewController
        sut.loadViewIfNeeded()

        searchTrainPresenter = SearchTrainPresenter()
        searchTrainPresenter.view = sut
    }

    override func tearDown() {
        super.tearDown()
        storyboard = nil
        sut = nil
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
        let searchButtonActions = try XCTUnwrap(searchButton.actions(forTarget: sut, forControlEvent: .touchUpInside),
                                                "Search button does not have any actions assigned to it")

        // Assert
        XCTAssertEqual(searchButtonActions.count, 1)
        XCTAssertEqual(searchButtonActions.first, "searchTrainsTapped:",
                       "There is no action with a name SearchTrainButtonTapped assigned to SearchTrain button")
    }

    func testSearchTrainViewController_WhenSearchButtonTapped_InvokesSearchTrainProcess() {
        // Arrange
        let mockSearchTrainPresenter = SearchTrainPresenterMock()
        sut.presenter = mockSearchTrainPresenter

        // Act
        sut.searchButton.sendActions(for: .touchUpInside)

        // Assert
        XCTAssertTrue(mockSearchTrainPresenter.isSearchTappedCalled,
                      "The searchTapped() method was not called on a Presenter object when the search button was tapped in a SearchTrainViewController")
    }

    func testSearchTrainViewController_WhenFailedToFetchAllStation_ShouldHideTableViewAndStationListShouldBeZero() {
        // Arrange
        sut.trainsListTable.isHidden = false
        // Act
        searchTrainPresenter.failedToFetchAllStaions()

        // Assert
        XCTAssertTrue(sut.stationsList.count == 0, "stationsList count should be zero")
        XCTAssertTrue(sut.trainsListTable.isHidden == true, "Table should be hidden if it fails to get all stations due to network problem")
    }

    func testSearchTrainViewController_WhenNoNetworkAvailable_ShouldCallShowNoInternetAvailabilityMessage() {
        // Arrange
        sut.trainsListTable.isHidden = false

        // Act
        searchTrainPresenter.showNoInternetAvailabilityMessage()

        // Assert
        XCTAssertTrue(sut.stationsList.count == 0, "stationsList count should be zero")
        XCTAssertTrue(sut.trainsListTable.isHidden == true, "Table should be hidden if it fails to get all stations")

    }

    func testSearchTrainViewController_WhenFailedToFetchAllStation_ShouldCallShowNoTrainAvailbilityFromSource() {
        // Arrange
        sut.trainsListTable.isHidden = false
        let viewWithTag = sut.view.viewWithTag(PROGRESS_INDICATOR_VIEW_TAG)

        // Act
        searchTrainPresenter.showNoTrainAvailbilityFromSource()

        // Assert
        XCTAssertNotNil(searchTrainPresenter.view, "Search train view controller should not be Nil")
        XCTAssertTrue(viewWithTag?.superview == nil, "Progress Indicator view should not have super view")
    }

    func testSearchTrainViewController_WhenFetchTrainList_ShouldCallUpdateLatestTrainList() {
        // Arrange
        let trainList = TestUtility.allStationsFromSourceCodeBFSTC()?.trainsList ?? []
        let viewWithTag = sut.view.viewWithTag(PROGRESS_INDICATOR_VIEW_TAG)

        // Act
        searchTrainPresenter.fetchedTrainsList(trainsList: trainList)

        // Assert
        XCTAssertTrue(sut.trains.isEmpty == false, "Station list shoud not be empty")
        XCTAssertTrue(viewWithTag?.superview == nil, "Progress indicator view should not have super view")
        XCTAssertTrue(sut.trainsListTable.isHidden == false, "Table should not be hidden if there is a list of stations")

    }

    func testSearchTrainViewController_WhenTrainListIsEmpty_ShouldCallShowNoTrainsFoundAlert() {
        // Arrange
        let viewWithTag = sut.view.viewWithTag(PROGRESS_INDICATOR_VIEW_TAG)
        sut.alertViewController = nil

        // Act
        searchTrainPresenter.fetchedTrainsList(trainsList: nil)

        // Assert
        XCTAssertNotNil(sut.alertViewController, "Alert view controller should not be nil")
        XCTAssertTrue(viewWithTag?.superview == nil, "Progress indicator view should not have super view")
    }

    func testSearchTrainViewController_WhenInvailidSourceAndDestinationProvided_ShouldCallShowInvalidSourceOrDestinationAlert() {
        // Arrange
        let invalidSource = "ABC"
        let invalidDestination = "XYZ"
        sut.alertViewController = nil
        let viewWithTag = sut.view.viewWithTag(PROGRESS_INDICATOR_VIEW_TAG)

        // Act
        searchTrainPresenter.searchTapped(source: invalidSource, destination: invalidDestination)

        // Assert
        XCTAssertNotNil(sut.alertViewController, "Alert view controller should not be nil")
        XCTAssertTrue(viewWithTag?.superview == nil, "Progress indicator view should not have super view")
    }
}
