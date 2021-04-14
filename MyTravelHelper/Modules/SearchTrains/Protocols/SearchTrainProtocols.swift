//
//  SearchTrainProtocols.swift
//  MyTravelHelper
//
//  Created by Satish on 11/03/19.
//  Copyright © 2019 Sample. All rights reserved.
//

import UIKit

protocol ViewToPresenterProtocol: class {
    var view: PresenterToViewProtocol? {get set}
    var interactor: PresenterToInteractorProtocol? {get set}
    var router: PresenterToRouterProtocol? {get set}
    func fetchallStations()
    func searchTapped(source: String, destination: String)
}

protocol PresenterToViewProtocol: class {
    func saveFetchedStations(stations: [Station]?)
    func updateLatestTrainList(trainsList: [StationTrain])
    func showInvalidSourceOrDestinationAlert()
    func showNoTrainsFoundAlert()
    func showNoTrainAvailbilityFromSource()
    func showNoInternetAvailabilityMessage()
    func showFailedToFetchAllStaionsMessage()
}

protocol PresenterToRouterProtocol: class {
    static func createModule() -> SearchTrainViewController
}

protocol PresenterToInteractorProtocol: class {
    init(webService: WebServiceProtocol)
    var webService: WebServiceProtocol { get }
    var presenter: InteractorToPresenterProtocol? { get set }
    func fetchallStations()
    func fetchTrainsFromSource(sourceCode: String, destinationCode: String)
}

protocol InteractorToPresenterProtocol: class {
    func stationListFetched(list: [Station])
    func fetchedTrainsList(trainsList: [StationTrain]?)
    func showNoTrainAvailbilityFromSource()
    func showNoInternetAvailabilityMessage()
    func failedToFetchAllStaions()
}

protocol WebServiceProtocol: class {
    func fetchallStations(completionHandler: @escaping (Stations?, WebServicesError?) -> Void)
    func fetchTrainsFromSource(sourceCode: String, completionHandler: @escaping (StationData?, WebServicesError?) -> Void)
    func getTrainMovements(trainCode: String, trainDate: String, completionHandler: @escaping (TrainMovementsData?, WebServicesError?) -> Void)
}
