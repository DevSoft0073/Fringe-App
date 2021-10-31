//
//  GetAllChatUsers.swift
//  Fringe
//
//  Created by MyMac on 10/31/21.
//
import Foundation

// MARK: - GetAllChatUsers
struct GetAllChatUsers: Codable , Hashable {
    var id, userID, golfID, hostID: String?
    var roomID, createdAt: String?
    var image: String?
    var name, lastMessage, lastMessageTime, messageCount: String?

    func toMessageGroupModal() -> MessageModal {
        
        let group = MessageModal(id: id, userID: userID, golfID: golfID, hostID: hostID, roomID: roomID, createdAt: createdAt, image: image, name: name, lastMessage: lastMessage, lastMessageTime: lastMessageTime, messageCount: messageCount)
        return group
    }
    
    var unixDate: Int {
        return Int(lastMessageTime ?? createdAt ?? String()) ?? .zero
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case golfID = "golf_id"
        case hostID = "host_id"
        case roomID = "room_id"
        case createdAt = "created_at"
        case image, name, lastMessage, lastMessageTime, messageCount
    }
}

// MARK: GetAllChatUsers convenience initializers and mutators

extension GetAllChatUsers {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(GetAllChatUsers.self, from: data)
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
