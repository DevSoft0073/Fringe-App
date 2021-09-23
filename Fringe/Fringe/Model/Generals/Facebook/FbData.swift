//
//  FbData.swift
//  Fringe
//
//  Created by MyMac on 9/22/21.
//

import Foundation

struct FbData {
    var firstName: String
    var lastName: String
    var email: String
    var imgUrl: String
    
     init(firstName: String, lastName: String, email: String, imgUrl: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.imgUrl = imgUrl
    }    
}
