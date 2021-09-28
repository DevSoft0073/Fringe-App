//
//  RequestModal.swift
//  Fringe
//
//  Created by MyMac on 9/8/21.
//

import Foundation

// MARK: - RequestListingModal
struct RequestListingModal: Codable, Hashable {
    var id, userID, golfID, bookingID: String?
    var dates, rejectReason, bookedStatus, totalGuest: String?
    var cancelStatus, paymentStatus, golfPaymentStatus, refundRequest: String?
    var sessionComplete, paymentPending, amountToBePaid, refundPayment: String?
    var refundStatus, refundReason, creationAt, golfCourseName: String?
    var requestListingModalDescription, golfPrice, location: String?
    var golfImages: [String]?
    var rating, date, status: String?

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
        case golfCourseName = "golf_course_name"
        case requestListingModalDescription = "description"
        case golfPrice, location
        case golfImages = "golf_images"
        case rating, date, status
    }
}

// MARK: RequestListingModal convenience initializers and mutators

extension RequestListingModal {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(RequestListingModal.self, from: data)
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
