//
//  SearchTrainPresenterMock.swift
//  MyTravelHelperTests
//
//  Created by ShailAadi on 13/4/21.
//  Copyright © 2021 Sample. All rights reserved.
//

import Foundation
@testable import MyTravelHelper
import XCTest

// swiftlint:disable identifier_name
class SearchTrainPresenterMock: InteractorToPresenterProtocol, ViewToPresenterProtocol {
    var view: PresenterToViewProtocol?
    var interactor: PresenterToInteractorProtocol?
    var router: PresenterToRouterProtocol?

    var isStationListFetchedCalled = false
    var isFailedToFetchAllStaionsCalled = false
    var isFetchedTrainsListCalled = false
    var isShowNoInternetAvailabilityMessageCalled = false
    var isShowNoTrainAvailbilityFromSourceCalled = false
    var isSearchTappedCalled = false

    func fetchallStations() {

    }

    func searchTapped(source: String, destination: String) {
        isSearchTappedCalled = true
    }

    func failedToFetchAllStaions() {
        isFailedToFetchAllStaionsCalled = true
    }

    func stationListFetched(list: [Station]) {
        isStationListFetchedCalled = true
    }

    func fetchedTrainsList(trainsList: [StationTrain]?) {
        isFetchedTrainsListCalled = true
    }

    func showNoTrainAvailbilityFromSource() {
        isShowNoTrainAvailbilityFromSourceCalled = true
    }

    func showNoInternetAvailabilityMessage() {
        isShowNoInternetAvailabilityMessageCalled = true
    }
}
// swiftlint:enable identifier_name
