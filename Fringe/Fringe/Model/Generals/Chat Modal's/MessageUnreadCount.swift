//
//  MessageUnreadCount.swift
//  Fringe
//
//  Created by MyMac on 10/31/21.
//

import Foundation

// MARK: - MessageUnreadCount
struct MessageUnreadCount: Codable {
    var count: String?
}

// MARK: MessageUnreadCount convenience initializers and mutators

extension MessageUnreadCount {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(MessageUnreadCount.self, from: data)
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
