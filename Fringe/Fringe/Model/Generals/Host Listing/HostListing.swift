//
//  HostListing.swift
//  Fringe
//
//  Created by MyMac on 10/16/21.
//

import Foundation

// MARK: - HostlistingModal
struct HostlistingModal: Codable {
    var id, userID, golfID, bookingID: String?
    var dates, rejectReason, bookedStatus, totalGuest: String?
    var cancelStatus, paymentStatus, golfPaymentStatus, refundRequest: String?
    var sessionComplete, paymentPending, amountToBePaid, refundPayment: String?
    var refundStatus, refundReason, creationAt: String?
    var userDetails: UserDetails?
    var golfCourseName, hostlistingModalDescription, location, date: String?
    var status: String?

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case golfID = "golf_id"
        case bookingID = "booking_id"
        case dates
        case rejectReason = "reject_reason"
        case bookedStatus = "booked_status"
        case totalGuest
        case cancelStatus = "cancel_status"
        case paymentStatus = "payment_status"
        case golfPaymentStatus = "golf_payment_status"
        case refundRequest = "refund_request"
        case sessionComplete = "session_complete"
        case paymentPending = "payment_pending"
        case amountToBePaid = "amount_to_be_paid"
        case refundPayment = "refund_payment"
        case refundStatus = "refund_status"
        case refundReason = "refund_reason"
        case creationAt = "creation_at"
        case userDetails
        case golfCourseName = "golf_course_name"
        case hostlistingModalDescription = "description"
        case location, date, status
    }
}

// MARK: HostlistingModal convenience initializers and mutators

extension HostlistingModal {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(HostlistingModal.self, from: data)
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

import Foundation

// MARK: - UserDetails
struct UserDetails: Codable {
    var userID, isRequest, golfID, isgolfRegistered: String?
    var stripeAccountStatus: String?
    var image: String?
    var userName, accountID, customerID, firstName: String?
    var lastName, email, countryCode, timeZone: String?
    var dob, gender, mobileNo, hometown: String?
    var profession, memberCourse, golfHandicap, password: String?
    var confirmPassword, emailVerification, verificationCode, disable: String?
    var allowPush, allowLocation, fbToken, googleToken: String?
    var appleToken, creationAt: String?

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
    }
}

// MARK: UserDetails convenience initializers and mutators

extension UserDetails {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(UserDetails.self, from: data)
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

