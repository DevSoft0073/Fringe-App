////
////  UserModal.swift
////  NewProject
////
////  Created by Dharmesh Avaiya on 22/08/20.
////  Copyright © 2020 dharmesh. All rights reserved.
////
//
//import Foundation
//
//// MARK: - UserModal
//struct UserModal: Codable {
//    var userID, isRequest, golfID, stripeAccountStatus: String?
//    var image, userName, accountID, customerID: String?
//    var firstName, lastName, timeZone, isgolfRegistered: String?
//    var dob, gender, mobileNo, hometown: String?
//    var profession, memberCourse, golfHandicap, password: String?
//    var confirmPassword, email, emailVerification, verificationCode: String?
//    var disable, allowPush, allowLocation, fbToken: String?
//    var googleToken, appleToken, creationAt, authorizationToken: String?
//    var isRegistered: String?
//
//    func toMockUser() -> MockUser {
////        if studio == "1" {
////            return MockUser(senderId: studioID ??  String(), displayName: fullName)
////        } else {
////            return MockUser(senderId: userID ??  String(), displayName: fullName)
////        }
//        if PreferenceManager.shared.curretMode == "1"{
//            return MockUser(senderId: userID ??  String(), displayName: userName ?? String())
//        }else{
//            return MockUser(senderId: userID ??  String(), displayName: userName ?? String())
//        }
//    }
//
//
//    enum CodingKeys: String, CodingKey {
//        case userID = "user_id"
//        case isRequest = "is_request"
//        case golfID = "golf_id"
//        case stripeAccountStatus = "stripe_account_status"
//        case image
//        case userName = "user_name"
//        case accountID = "account_id"
//        case customerID = "customer_id"
//        case firstName = "first_name"
//        case lastName = "last_name"
//        case timeZone = "time_zone"
//        case isgolfRegistered = "isgolf_registered"
//        case dob, gender
//        case mobileNo = "mobile_no"
//        case hometown, profession
//        case memberCourse = "member_course"
//        case golfHandicap = "golf_handicap"
//        case password
//        case confirmPassword = "confirm_password"
//        case email
//        case emailVerification = "email_verification"
//        case verificationCode = "verification_code"
//        case disable
//        case allowPush = "allow_push"
//        case allowLocation = "allow_location"
//        case fbToken = "fb_token"
//        case googleToken = "google_token"
//        case appleToken = "apple_token"
//        case creationAt = "creation_at"
//        case authorizationToken = "authorization_token"
//        case isRegistered = "is_registered"
//    }
//
//    var isClubRegistered: Bool {
//        if isgolfRegistered == "0" {
//            return false
//        }
//        return isgolfRegistered == "1" ? true : false
//    }
//
//}
//
//// MARK: UserModal convenience initializers and mutators
//
//extension UserModal {
//    init(data: Data) throws {
//        self = try newJSONDecoder().decode(UserModal.self, from: data)
//    }
//
//    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
//        guard let data = json.data(using: encoding) else {
//            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
//        }
//        try self.init(data: data)
//    }
//
//    init(fromURL url: URL) throws {
//        try self.init(data: try Data(contentsOf: url))
//    }
//
//    func jsonData() throws -> Data {
//        return try newJSONEncoder().encode(self)
//    }
//
//    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
//        return String(data: try self.jsonData(), encoding: encoding)
//    }
//}
//


// UserModal.swift

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let userModal = try UserModal(json)

import Foundation

// MARK: - UserModal
struct UserModal: Codable {
    var userID, isRequest, golfID, isgolfRegistered: String?
    var stripeAccountStatus, image, userName, accountID: String?
    var customerID, firstName, lastName, email: String?
    var countryCode, timeZone, dob, gender: String?
    var mobileNo, hometown, profession, memberCourse: String?
    var golfHandicap, password, confirmPassword, emailVerification: String?
    var verificationCode, disable, allowPush, allowLocation: String?
    var fbToken, googleToken, appleToken, creationAt: String?
    var authorizationToken: String?
    
    func toMockUser() -> MockUser {
//        if studio == "1" {
//            return MockUser(senderId: studioID ??  String(), displayName: fullName)
//        } else {
//            return MockUser(senderId: userID ??  String(), displayName: fullName)
//        }
        if PreferenceManager.shared.curretMode == "1"{
            return MockUser(senderId: userID ??  String(), displayName: userName ?? String())
        }else{
            return MockUser(senderId: userID ??  String(), displayName: userName ?? String())
        }
    }
    

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case isRequest = "is_request"
        case golfID = "golf_id"
        case isgolfRegistered = "isgolf_registered"
        case stripeAccountStatus = "stripe_account_status"
        case image
        case userName = "user_name"
        case accountID = "account_id"
        case customerID = "customer_id"
        case firstName = "first_name"
        case lastName = "last_name"
        case email
        case countryCode = "Country_code"
        case timeZone = "time_zone"
        case dob, gender
        case mobileNo = "mobile_no"
        case hometown, profession
        case memberCourse = "member_course"
        case golfHandicap = "golf_handicap"
        case password
        case confirmPassword = "confirm_password"
        case emailVerification = "email_verification"
        case verificationCode = "verification_code"
        case disable
        case allowPush = "allow_push"
        case allowLocation = "allow_location"
        case fbToken = "fb_token"
        case googleToken = "google_token"
        case appleToken = "apple_token"
        case creationAt = "creation_at"
        case authorizationToken = "authorization_token"
    }
    
    var isClubRegistered: Bool {
        if isgolfRegistered == "0" {
            return false
        }
        return isgolfRegistered == "1" ? true : false
    }
}

// MARK: UserModal convenience initializers and mutators

extension UserModal {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(UserModal.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
