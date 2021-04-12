//
//  WebServicesError.swift
//  MyTravelHelper
//
//  Created by ShailAadi on 10/4/21.
//  Copyright © 2021 Sample. All rights reserved.
//

import Foundation

enum WebServicesError: LocalizedError, Equatable {

    case invalidResponseModel
    case invalidRequestURLString
    case networkNotReachable
    case failedRequest(description: String)

    var errorDescription: String? {
        switch self {
        case .failedRequest(let description):
            return description
        case .invalidResponseModel, .invalidRequestURLString, .networkNotReachable:
            return ""
        }
    }
}
