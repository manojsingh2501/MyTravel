//
//  MockWebService.swift
//  MyTravelHelperTests
//
//  Created by ShailAadi on 13/4/21.
//  Copyright © 2021 Sample. All rights reserved.
//

import Foundation
import XCTest
@testable import MyTravelHelper

class MockWebService: WebServiceProtocol {
    var shouldShowError = false
    var expectation: XCTestExpectation?

    func fetchallStations(completionHandler: @escaping (Stations?, WebServicesError?) -> Void) {
        if shouldShowError {
            completionHandler(nil, .networkNotReachable)
        } else {
            completionHandler(TestUtility.allStations(), nil)
        }
        expectation?.fulfill()
    }

    func fetchTrainsFromSource(sourceCode: String, completionHandler: @escaping (StationData?, WebServicesError?) -> Void) {
        
        if shouldShowError {
            completionHandler(nil, .networkNotReachable)
            expectation?.fulfill()
        } else {
            completionHandler(TestUtility.allStationsFromSourceCodeBFSTC(), nil)
        }
    }

    func getTrainMovements(trainCode: String, trainDate: String, completionHandler: @escaping (TrainMovementsData?, WebServicesError?) -> Void) {
        if shouldShowError {
            completionHandler(nil, .networkNotReachable)
        } else {
            completionHandler(TestUtility.allTrainMovementForTrainID_A149(), nil)
        }
        expectation?.fulfill()
    }
}
