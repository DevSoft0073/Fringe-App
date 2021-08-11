//
//  DateTimeManager.swift
//  NewProject
//
//  Created by Dharmesh Avaiya on 6/24/20.
//  Copyright © 2020 dharmesh. All rights reserved.
//

import UIKit

public struct DateFormate {
    
    static let MMM_DD_COM_yyyy = "MMM dd, yyyy"
}

class DateTimeManager: NSObject {
    
    let dateFormatter = DateFormatter()
    
    //------------------------------------------------------
    
    //MARK: Shared
    
    static let shared = DateTimeManager()
    
    //------------------------------------------------------
    
    //MARK: Public
    
    func dateFrom(unix: Int) -> Date {
        return Date(timeIntervalSince1970: TimeInterval(unix/1000))
    }
    
    func dateFrom(unix: Int, inFormate: String) -> String {
        let date = dateFrom(unix: unix)
        dateFormatter.dateFormat = inFormate
        return dateFormatter.string(from: date)
    }
    
    //------------------------------------------------------
}
