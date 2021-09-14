//
//  BookingRequestModal.swift
//  Fringe
//
//  Created by MyMac on 9/14/21.
//

import Foundation

// MARK: - BookingRequestModal
struct BookingRequestModal: Codable {
    var id, userID, golfID, bookingID: String?
    var dates, rejectReson, bookedStatus, cancelStatus: String?
    var paymentStatus, golfPaymentStatus, refundRequest, sessionComplete: String?
    var paymentPending, amountToBePaid, refundPayment, refundStatus: String?
    var refundReason, creationAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case golfID = "golf_id"
        case bookingID = "booking_id"
        case dates
        case rejectReson = "reject_reson"
        case bookedStatus = "booked_status"
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
    }
}

// MARK: BookingRequestModal convenience initializers and mutators

extension BookingRequestModal {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(BookingRequestModal.self, from: data)
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

