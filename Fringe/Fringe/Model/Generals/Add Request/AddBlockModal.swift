//
//  AddBlockModal.swift
//  Fringe
//
//  Created by MyMac on 9/17/21.
//

import Foundation

// MARK: - AddBlockDate

struct AddBlockDate: Codable {
    var id, golfID, userID, dates: String?
    var isblock, disable, creationAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case golfID = "golf_id"
        case userID = "user_id"
        case dates, isblock, disable
        case creationAt = "creation_at"
    }
}

// MARK: AddBlockDate convenience initializers and mutators

extension AddBlockDate {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(AddBlockDate.self, from: data)
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
