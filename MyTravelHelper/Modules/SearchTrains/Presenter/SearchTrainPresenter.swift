//
//  SearchTrainPresenter.swift
//  MyTravelHelper
//
//  Created by Satish on 11/03/19.
//  Copyright © 2019 Sample. All rights reserved.
//

import UIKit

class SearchTrainPresenter: ViewToPresenterProtocol {
    var stationsList: [Station] = [Station]()
    var interactor: PresenterToInteractorProtocol?
    var router: PresenterToRouterProtocol?
    var view: PresenterToViewProtocol?

    func searchTapped(source: String, destination: String) {
        guard let sourceStationCode = getStationCode(stationName: source), let destinationStationCode = getStationCode(stationName: destination) else {
            view?.showInvalidSourceOrDestinationAlert()
            return
        }
        interactor?.fetchTrainsFromSource(sourceCode: sourceStationCode, destinationCode: destinationStationCode)
    }

    func fetchallStations() {
        interactor?.fetchallStations()
    }

    private func getStationCode(stationName: String) -> String? {
        let stationCode = stationsList.first { $0.stationDesc == stationName }
        return stationCode?.stationCode.lowercased()
    }
}

extension SearchTrainPresenter: InteractorToPresenterProtocol {
    func showNoInternetAvailabilityMessage() {
        view?.showNoInternetAvailabilityMessage()
    }

    func showNoTrainAvailbilityFromSource() {
        view?.showNoTrainAvailbilityFromSource()
    }

    func fetchedTrainsList(trainsList: [StationTrain]?) {
        if let trainsList = trainsList {
            view?.updateLatestTrainList(trainsList: trainsList)
        } else {
            view?.showNoTrainsFoundAlert()
        }
    }

    func stationListFetched(list: [Station]) {
        stationsList = list
        view?.saveFetchedStations(stations: list)
    }

    func failedToFetchAllStaions() {
        view?.showFailedToFetchAllStaionsMessage()
    }
}
