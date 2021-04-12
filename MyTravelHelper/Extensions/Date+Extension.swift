//
//  Date+Extension.swift
//  MyTravelHelper
//
//  Created by ShailAadi on 11/4/21.
//  Copyright © 2021 Sample. All rights reserved.
//

import Foundation

extension Date {
    func toString(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
