//
//  UserModal.swift
//  NewProject
//
//  Created by Dharmesh Avaiya on 22/08/20.
//  Copyright © 2020 dharmesh. All rights reserved.
//

import Foundation

// MARK: - UserModal
struct UserModal: Codable {
    var userID: String?
    var image: String?
    var userName, firstName, lastName, timeZone: String?
    var isgolfRegistered, dob, gender, mobileNo: String?
    var hometown, profession, memberCourse, golfHandicap: String?
    var password, confirmPassword, email, emailVerification, authorizationToken: String?
    var verificationCode, disable, allowPush, allowLocation: String?
    var fbToken, googleToken, appleToken, creationAt: String?

    
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
        case image
        case userName = "user_name"
        case firstName = "first_name"
        case lastName = "last_name"
        case timeZone = "time_zone"
        case isgolfRegistered = "isgolf_registered"
        case dob, gender
        case mobileNo = "mobile_no"
        case hometown, profession
        case memberCourse = "member_course"
        case golfHandicap = "golf_handicap"
        case password
        case confirmPassword = "confirm_password"
        case email
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
        if isgolfRegistered == "2" {
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
