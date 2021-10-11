//
//  NotificationListing.swift
//  Fringe
//
//  Created by MyMac on 9/14/21.
//

import Foundation

// MARK: - NotificationModal
struct NotificationModal: Codable, Hashable {
    var notificationID, title, message, userID: String?
    var senderID, golfID, requestID, senderRole: String?
    var requestStatus, notificationType, roomID, seen: String?
    var creationAt, golfCourseName, notificationModalDescription: String?
    var image: String?

    enum CodingKeys: String, CodingKey {
        case notificationID = "notification_id"
        case title, message
        case userID = "user_id"
        case senderID = "sender_id"
        case golfID = "golf_id"
        case requestID = "request_id"
        case senderRole = "sender_role"
        case requestStatus = "request_status"
        case notificationType = "notification_type"
        case roomID = "room_id"
        case seen
        case creationAt = "creation_at"
        case golfCourseName = "golf_course_name"
        case notificationModalDescription = "description"
        case image
    }
}

// MARK: NotificationModal convenience initializers and mutators

extension NotificationModal {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(NotificationModal.self, from: data)
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

