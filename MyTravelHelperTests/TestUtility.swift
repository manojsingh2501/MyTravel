//
//  TestUtility.swift
//  MyTravelHelperTests
//
//  Created by ShailAadi on 13/4/21.
//  Copyright © 2021 Sample. All rights reserved.
//

import Foundation
import XMLParsing
@testable import MyTravelHelper

class TestUtility {

    static func allStations() -> Stations? {
        guard let xmlData = dataFromFile(fileName: "AllStations", ofType: ".xml") else {
            return nil
        }
        return try? XMLDecoder().decode(Stations.self, from: xmlData)
    }
    
    static func allStationsFromSourceCodeBFSTC() -> StationData? {
        guard let xmlData = dataFromFile(fileName: "StationDataForTrainCode_BFSTC", ofType: ".xml") else {
            return nil
        }
        return try? XMLDecoder().decode(StationData.self, from: xmlData)
    }

    static func allTrainMovementForTrainID_A149() -> TrainMovementsData? {
        guard let xmlData = dataFromFile(fileName: "TrainMovementForTrainID_A149", ofType: ".xml") else {
            return nil
        }
        return try? XMLDecoder().decode(TrainMovementsData.self, from: xmlData)
    }

    static func dataFromFile(fileName: String, ofType: String) -> Data? {
        let bundle = Bundle(for: WebServiceTests.self)
        guard let path = bundle.path(forResource: fileName, ofType: ofType) else {
            return nil
        }
        return try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
    }
}

