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
    var userID, image, userName, firstName: String?
    var lastName, timeZone, golfID, dob: String?
    var gender, mobileNo, hometown, profession: String?
    var memberCourse, golfHandicap, password, confirmPassword: String?
    var email, emailVerification, verificationCode, disable: String?
    var allowPush, allowLocation, fbToken, googleToken: String?
    var appleToken, creationAt, authorizationToken: String?

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case image
        case userName = "user_name"
        case firstName = "first_name"
        case lastName = "last_name"
        case timeZone = "time_zone"
        case golfID = "golf_id"
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
