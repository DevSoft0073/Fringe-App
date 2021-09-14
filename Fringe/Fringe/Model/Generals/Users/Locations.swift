//
//  Locations.swift
//  Fringe
//
//  Created by MyMac on 9/14/21.
//

import Foundation
import UIKit
import MapKit

class Location: NSObject {
    var locationName: String!
    var location: String!

    init(locationName: String, location: String) {
        self.locationName = locationName
        self.location = location
    }
}
