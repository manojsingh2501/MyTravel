//
//  WebServiceTests.swift
//  MyTravelHelperTests
//
//  Created by ShailAadi on 11/4/21.
//  Copyright © 2021 Sample. All rights reserved.
//

import XCTest
@testable import MyTravelHelper

class WebServiceTests: XCTestCase {
    var sut: WebService!

    override func setUp() {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        let urlSession = URLSession(configuration: config)
        sut = WebService(urlSession: urlSession)
    }

    override func tearDown() {
        sut = nil
        MockURLProtocol.stubResponseData = nil
        MockURLProtocol.error = nil
    }

    func testWebservice_WhenSuccessfulResponseGiven_ShouldFetchAllStations() {
        // Arrange
        let totalNumberOfStations = 167
        let xmlData = dataFromFile(fileName: "AllStations", ofType: ".xml")
        MockURLProtocol.stubResponseData = xmlData
        let expectation = self.expectation(description: "Fetch all stations expectation")

        // Act
        sut.fetchallStations { stations, _ in
            // Assert
            XCTAssertNotNil(stations, "It should have fetched all stations but returning Nil")
            XCTAssertTrue(stations?.stationsList.count == totalNumberOfStations, "Total number of stations should be 167")
            expectation.fulfill()
        }
        self.wait(for: [expectation], timeout: 5.0)
    }

    func testWebservice_WhenVailidTrainSourceProvided_ShouldFetchAllStationTrains() {
        // Arrange
        let numberOfStaionTrains = 1
        let trainSourceCode = "BFSTC"
        let xmlData = dataFromFile(fileName: "StationDataForTrainCode_BFSTC", ofType: ".xml")
        MockURLProtocol.stubResponseData = xmlData
        let expectation = self.expectation(description: "Fetch all station trains for source station code `BFSTC` expectation")

        // Act
        sut.fetchTrainsFromSource(sourceCode: trainSourceCode) { stationData, _ in
            // Assert
            XCTAssertNotNil(stationData, "It should have fetched all station trains for station code `BFSTC` but returning Nil")
            XCTAssertTrue(stationData?.trainsList.count == numberOfStaionTrains, "Total number of station trains should be 1")
            expectation.fulfill()
        }
        self.wait(for: [expectation], timeout: 5.0)
    }

    func testWebservice_WhenVailidTrainCodeProvided_ShouldFetchAllTrainMovements() {
        // Arrange
        let trainID = "A149"
        let dateString = Date().toString(format: "dd/MM/yyyy")
        let allStationXMLData = dataFromFile(fileName: "TrainMovementForTrainID_A149", ofType: ".xml")
        MockURLProtocol.stubResponseData = allStationXMLData
        let expectation = self.expectation(description: "Fetch all train movements expectation")

        // Act
        sut.getTrainMovements(trainCode: trainID, trainDate: dateString) { trainMovment, _ in
            // Assert
            XCTAssertNotNil(trainMovment, "It should have fetched all train movements but returning Nil")
            expectation.fulfill()
        }

        self.wait(for: [expectation], timeout: 5.0)
    }

    func dataFromFile(fileName: String, ofType: String) -> Data? {
        let bundle = Bundle(for: WebServiceTests.self)
        guard let path = bundle.path(forResource: fileName, ofType: ofType) else {
            return nil
        }
        return try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
    }
}
