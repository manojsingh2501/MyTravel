//
//  SearchTrainInteractor.swift
//  MyTravelHelper
//
//  Created by Satish on 11/03/19.
//  Copyright © 2019 Sample. All rights reserved.
//

import Foundation
import XMLParsing

class SearchTrainInteractor: PresenterToInteractorProtocol {
    var _sourceStationCode = String()
    var _destinationStationCode = String()
    weak var presenter: InteractorToPresenterProtocol?
    var webService: WebServiceProtocol

    required init(webService: WebServiceProtocol) {
        self.webService = webService
    }

    func fetchallStations() {
        webService.fetchallStations { [weak self] station, _ in
            guard let strongSelf = self else { return }
            strongSelf.presenter!.stationListFetched(list: station!.stationsList)
        }
    }

    func fetchTrainsFromSource(sourceCode: String, destinationCode: String) {
        _sourceStationCode = sourceCode
        _destinationStationCode = destinationCode

        webService.fetchTrainsFromSource(sourceCode: sourceCode) { [weak self] stationData, error in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                if let error = error {
                    strongSelf.errorHandler(error: error)
                } else if let trainsList = stationData?.trainsList {
                    strongSelf.proceesTrainListforDestinationCheck(trainsList: trainsList)
                } else {
                    strongSelf.presenter?.showNoTrainAvailbilityFromSource()
                }
            }
        }
    }

    func errorHandler(error: WebServicesError) {
        switch error {
        case .networkNotReachable:
            presenter?.showNoInternetAvailabilityMessage()
        case .failedRequest, .invalidRequestURLString, .invalidResponseModel:
            presenter?.showNoTrainAvailbilityFromSource()
        }
    }

    func destinationTrain(movements: [TrainMovement]) -> TrainMovement? {
            let sourceIndex = movements.firstIndex(where: { $0.locationCode.caseInsensitiveCompare(_sourceStationCode) == .orderedSame })
            let destinationIndex = movements.firstIndex(where: { $0.locationCode.caseInsensitiveCompare(_destinationStationCode) == .orderedSame })
            let desiredStationMoment = movements.filter { $0.locationCode.caseInsensitiveCompare(_destinationStationCode) == .orderedSame }
            let isDestinationAvailable = desiredStationMoment.count == 1
            
            if isDestinationAvailable  && sourceIndex! < destinationIndex! {
                return desiredStationMoment.first
            } else {
                return nil
            }
    }
}

private extension SearchTrainInteractor {
    func proceesTrainListforDestinationCheck(trainsList: [StationTrain]) {
        var allTrainsList = trainsList
        let group = DispatchGroup()
        let dateString = Date().toString(format: "dd/MM/yyyy")

        for index  in 0...trainsList.count-1 {
            group.enter()

            WebService().getTrainMovements(trainCode: trainsList[index].trainCode, trainDate: dateString) { [weak self] trainMovementsData, _ in
                guard let strongSelf = self else { return }
                if let movements = trainMovementsData?.trainMovements {
                    allTrainsList[index].destinationDetails = strongSelf.destinationTrain(movements: movements)
                }
                group.leave()
            }
        }

        group.notify(queue: DispatchQueue.main) {
            let sourceToDestinationTrains = allTrainsList.filter { $0.destinationDetails != nil }
            self.presenter!.fetchedTrainsList(trainsList: sourceToDestinationTrains)
        }
    }
}
