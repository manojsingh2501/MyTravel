//
//  SearchTrainPresenterTests.swift
//  MyTravelHelperTests
//
//  Created by Satish on 11/03/19.
//  Copyright © 2019 Sample. All rights reserved.
//

import XCTest
@testable import MyTravelHelper

class SearchTrainPresenterTests: XCTestCase {
    var presenter: SearchTrainPresenter!
    var view = SearchTrainMockView()
    var interactor: SearchTrainInteractorMock!

    override func setUp() {
        let mockWebService = MockWebService()
        interactor = SearchTrainInteractorMock(webService: mockWebService)
        presenter = SearchTrainPresenter()
        presenter.view = view
        presenter.interactor = interactor
        interactor.presenter = presenter
    }

    override func tearDown() {
        presenter = nil
    }

    func testfetchallStations() {
        presenter.fetchallStations()
        XCTAssertTrue(view.isSaveFetchedStatinsCalled)
    }

    func testSearchTrainPresenter_WhenSearchWithInvalidSourceOrDestinationGiven_shouldCallShowInvalidSourceOrDestinationAlert() {
        // Arrange
        let invalidSource = "ABC"
        let invalidDestination = "XYZ"

        // Act
        presenter.searchTapped(source: invalidSource, destination: invalidDestination)

        // Assert
        XCTAssert(view.isShowInvalidSourceOrDestinationAlertCalled, "When invalid source or destination is provided `showInvalidSourceOrDestinationAlert` method should be called")

    }

    func testSearchTrainPresenter_WhenNoInternetIsAvailable_shouldCallShowInvalidSourceOrDestinationAlert() {
        // Arrange
        interactor.shouldReturnNoNetworkError = true
        
        // Act
        interactor.fetchallStations()

        // Assert
        XCTAssert(view.isshowNoInternetAvailabilityMessageCalled, "When internet is not available `showNoInternetAvailabilityMessage` method should be called")
    }
    
    func testTrainPresenter_WhenFetchAllStaion_StationListFetchedCall() {
//        interactor.fetchallStations()
    }
}

class SearchTrainMockView: PresenterToViewProtocol {
    var isSaveFetchedStatinsCalled = false
    var isShowInvalidSourceOrDestinationAlertCalled = false
    var isshowNoTrainsFoundAlertCalled = false
    var isShowNoTrainAvailbilityFromSourceCalled = false
    var isshowNoInternetAvailabilityMessageCalled = false

    func saveFetchedStations(stations: [Station]?) {
        isSaveFetchedStatinsCalled = true
    }

    func showInvalidSourceOrDestinationAlert() {
        isShowInvalidSourceOrDestinationAlertCalled = true
    }

    func updateLatestTrainList(trainsList: [StationTrain]) {

    }

    func showFailedToFetchAllStaionsMessage() {
        
    }

    func showNoTrainsFoundAlert() {
        isshowNoTrainsFoundAlertCalled = true
    }

    func showNoTrainAvailbilityFromSource() {
        isShowNoTrainAvailbilityFromSourceCalled = true
    }

    func showNoInternetAvailabilityMessage() {
        isshowNoInternetAvailabilityMessageCalled = true
    }

}

class SearchTrainInteractorMock: PresenterToInteractorProtocol {
    var webService: WebServiceProtocol
    var shouldReturnNoNetworkError = false

    var presenter: InteractorToPresenterProtocol?

    required init(webService: WebServiceProtocol) {
        self.webService = webService
    }

    func fetchallStations() {
        if shouldReturnNoNetworkError {
            presenter?.showNoInternetAvailabilityMessage()
        } else {
            let station = Station(desc: "Belfast Central", latitude: 54.6123, longitude: -5.91744, code: "BFSTC", stationId: 228)
            presenter?.stationListFetched(list: [station])
        }
    }

    func fetchTrainsFromSource(sourceCode: String, destinationCode: String) {

    }
}
