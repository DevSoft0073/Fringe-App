//
//  CreateRoomModal.swift
//  Fringe
//
//  Created by MyMac on 10/31/21.
//

import Foundation

// MARK: - CreateRoomModal
struct CreateRoomModal: Codable {
    var id, userID, golfID, hostID: String?
    var roomID, createdAt: String?
    var image: String?
    var name, lastMessage, messageCount: String?

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case golfID = "golf_id"
        case hostID = "host_id"
        case roomID = "room_id"
        case createdAt = "created_at"
        case image, name, lastMessage, messageCount
    }
}

// MARK: CreateRoomModal convenience initializers and mutators

extension CreateRoomModal {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(CreateRoomModal.self, from: data)
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
