//
//  PlayerMessagesModal.swift
//  Fringe
//
//  Created by MyMac on 9/29/21.
//

import Foundation

// MARK: - PlayerMessgaeModal
struct PlayerMessgaeModal: Codable {
    var userID, isRequest, golfID, stripeAccountStatus: String?
    var image: String?
    var userName, accountID, customerID, firstName: String?
    var lastName, timeZone, isgolfRegistered, dob: String?
    var gender, mobileNo, hometown, profession: String?
    var memberCourse, golfHandicap, password, confirmPassword: String?
    var email, emailVerification, verificationCode, disable: String?
    var allowPush, allowLocation, fbToken, googleToken: String?
    var appleToken, creationAt, lastmsg, lastmsgTime: String?
    var otheruserName: String?
    var otheruserImage: String?
    
    func toMessageGroupModal() -> MessageGroupModal {
        let group = MessageGroupModal(userID: userID, isRequest: isRequest, golfID: golfID, stripeAccountStatus: stripeAccountStatus, image: image, userName: userName, accountID: accountID, customerID: customerID, firstName: firstName, lastName: lastName, timeZone: timeZone, isgolfRegistered: isgolfRegistered, dob: dob, gender: gender, mobileNo: mobileNo, hometown: hometown, profession: profession, memberCourse: memberCourse, golfHandicap: golfHandicap, password: password, confirmPassword: confirmPassword, email: email, emailVerification: emailVerification, verificationCode: verificationCode, disable: disable, allowPush: allowPush, allowLocation: allowLocation, fbToken: fbToken, googleToken: googleToken, appleToken: appleToken, creationAt: creationAt, lastmsg: lastmsg, lastmsgTime: lastmsgTime, otheruserName: otheruserName, otheruserImage: otheruserImage)
        return group
    }
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case isRequest = "is_request"
        case golfID = "golf_id"
        case stripeAccountStatus = "stripe_account_status"
        case image
        case userName = "user_name"
        case accountID = "account_id"
        case customerID = "customer_id"
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
        case lastmsg
        case lastmsgTime = "lastmsg_time"
        case otheruserName = "otheruser_name"
        case otheruserImage = "otheruser_image"
    }
}

// MARK: PlayerMessgaeModal convenience initializers and mutators

extension PlayerMessgaeModal {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(PlayerMessgaeModal.self, from: data)
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
