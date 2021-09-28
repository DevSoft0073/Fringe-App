//
//  ResponseModal.swift
//  NewProject
//
//  Created by Dharmesh Avaiya on 22/08/20.
//  Copyright © 2020 dharmesh. All rights reserved.
//

import Foundation

struct ResponseModal<T: Codable>: Codable {
    
    var code, status: Int?
    let message: String?
    var data : T?

    enum CodingKeys: String, CodingKey {
        case code
        case status
        case message
        case data
    }
}
