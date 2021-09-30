//
//  AddEditMessage.swift
//  Fringe
//
//  Created by MyMac on 9/30/21.
//

import Foundation

// MARK: - AddEditMessageModal
struct AddEditMessageModal: Codable {
    var id, userID, message, roomID: String?
    var seen, creationAt, name: String?
    var image: String?

    func toMockMessage() -> MockMessage {
        
        let mockText = message ?? String()
        let mockUser = MockUser(senderId: id ?? String(), displayName: name ?? String())
        let messageId = id ??  String()
        let messageDate = DateTimeManager.shared.dateFrom(unix: Int(creationAt ?? String()) ?? .zero)
        let message = MockMessage(text: mockText, user: mockUser, messageId: messageId, date: messageDate)
        return message
    }
    
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

// MARK: AddEditMessageModal convenience initializers and mutators

extension AddEditMessageModal {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(AddEditMessageModal.self, from: data)
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
