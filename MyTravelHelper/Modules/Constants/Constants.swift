//
//  Constant.swift
//  MyTravelHelper
//
//  Created by ShailAadi on 11/4/21.
//  Copyright © 2021 Sample. All rights reserved.
//

import Foundation

struct Alert {
    static let actionTitle = "Okay"

    struct NoInternet {
        static let title = "No Internet"
        static let message = "Please Check your internet connection and try again"
    }

    struct NoTrainAvailbility {
        static let title = "No Trains"
        static let message = "Sorry No trains arriving source station in another 90 mins"
    }

    struct NoStations {
        static let title = "No Stations"
        static let message = "Sorry, something went wrong, failed to fetch all stations"
    }

    struct NoTrainsFound {
        static let title = "No Trains"
        static let message = "Sorry No trains Found from source to destination in another 90 mins"
    }

    struct InvalidSourceOrDestination {
        static let title = "Invalid Source/Destination"
        static let message = "Invalid Source or Destination Station names Please Check"
    }

    static let loadingStationMessage = "Please wait loading station list ...."
}

struct SearchTrainURLs {
    static let fetchAllStationURL = "http://api.irishrail.ie/realtime/realtime.asmx/getAllStationsXML"
    static let trainFromSource = "http://api.irishrail.ie/realtime/realtime.asmx/getStationDataByCodeXML?StationCode=%@"
    static let trainMovements = "http://api.irishrail.ie/realtime/realtime.asmx/getTrainMovementsXML?TrainId=%@&TrainDate=%@"
}
