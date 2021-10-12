//
//  BadgeModal.swift
//  Fringe
//
//  Created by MyMac on 10/12/21.
//

import Foundation

// MARK: - BadgeModal
struct BadgeModal: Codable {
    var getRequestCount, getNotificationCount, getChatListingCount: String?

    enum CodingKeys: String, CodingKey {
        case getRequestCount = "get_request_count"
        case getNotificationCount = "get_notification_count"
        case getChatListingCount = "get_chat_listing_count"
    }
}

// MARK: BadgeModal convenience initializers and mutators

extension BadgeModal {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(BadgeModal.self, from: data)
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
