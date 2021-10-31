//
//  GetAllMessages.swift
//  Fringe
//
//  Created by MyMac on 10/31/21.
//

import Foundation

// MARK: - GetAllMessages
struct GetAllMessages: Codable , Hashable{
    var id, userID, message, roomID: String?
    var seen, creationAt, name, image: String?

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case message
        case roomID = "room_id"
        case seen
        case creationAt = "creation_at"
        case name, image
    }
}

// MARK: GetAllMessages convenience initializers and mutators

extension GetAllMessages {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(GetAllMessages.self, from: data)
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
