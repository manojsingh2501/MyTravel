//
//  WebService.swift
//  MyTravelHelper
//
//  Created by ShailAadi on 10/4/21.
//  Copyright © 2021 Sample. All rights reserved.
//

import Foundation
import XMLParsing

class WebService: WebServiceProtocol {
    
    private var urlSession: URLSession
    
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    func fetchallStations(completionHandler: @escaping (Stations?, WebServicesError?) -> Void) {
        guard Reach().isNetworkReachable() else {
            completionHandler(nil, WebServicesError.networkNotReachable)
            return
        }

        guard let url = URL(string: SearchTrainURLs.fetchAllStationURL) else {
            completionHandler(nil, WebServicesError.invalidRequestURLString)
            return
        }

        let request = URLRequest(url: url)
        let dataTask = urlSession.dataTask(with: request) { data, _, error in
            
            if let requestError = error {
                completionHandler(nil, WebServicesError.failedRequest(description: requestError.localizedDescription))
                return
            }

            if let data = data, let stations = try? XMLDecoder().decode(Stations.self, from: data) {
                completionHandler(stations, nil)
            } else {
                completionHandler(nil, WebServicesError.invalidResponseModel)
            }
        }
        dataTask.resume()
    }

    func fetchTrainsFromSource(sourceCode: String, completionHandler: @escaping (StationData?, WebServicesError?) -> Void) {
        guard Reach().isNetworkReachable() else {
            completionHandler(nil, WebServicesError.networkNotReachable)
            return
        }

        let urlString = String(format: SearchTrainURLs.trainFromSource, sourceCode)
        guard let url = URL(string: urlString) else {
            completionHandler(nil, WebServicesError.invalidRequestURLString)
            return
        }

        let request = URLRequest(url: url)
        let dataTask = urlSession.dataTask(with: request) { data, _, error in
            if let requestError = error {
                completionHandler(nil, WebServicesError.failedRequest(description: requestError.localizedDescription))
                return
            }

            if let data = data, let stationData = try? XMLDecoder().decode(StationData.self, from: data) {
                completionHandler(stationData, nil)
            } else {
                completionHandler(nil, WebServicesError.invalidResponseModel)
            }
        }
        dataTask.resume()
    }

    func getTrainMovements(trainCode: String, trainDate: String, completionHandler: @escaping (TrainMovementsData?, WebServicesError?) -> Void) {
        guard Reach().isNetworkReachable() else {
            completionHandler(nil, WebServicesError.networkNotReachable)
            return
        }
        
        let urlString = String(format: SearchTrainURLs.trainMovements, trainCode, trainDate)
        guard let url = URL(string: urlString) else {
            completionHandler(nil, WebServicesError.invalidRequestURLString)
            return
        }

        let request = URLRequest(url: url)
        let dataTask = urlSession.dataTask(with: request) { data, _, error in
            
            if let requestError = error {
                completionHandler(nil, WebServicesError.failedRequest(description: requestError.localizedDescription))
                return
            }

            if let data = data, let trainMovements = try? XMLDecoder().decode(TrainMovementsData.self, from: data) {
                completionHandler(trainMovements, nil)
            } else {
                completionHandler(nil, WebServicesError.invalidResponseModel)
            }
        }
        dataTask.resume()
    }
}
