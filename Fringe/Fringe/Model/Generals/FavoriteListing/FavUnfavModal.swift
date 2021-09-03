//
//  FavUnfavModal.swift
//  Fringe
//
//  Created by MyMac on 9/3/21.
//

import Foundation

// MARK: - FavUnfvModal
struct FavUnfvModal: Codable {
    var golfID, isFav: String?

    enum CodingKeys: String, CodingKey {
        case golfID = "golf_id"
        case isFav
    }
}

// MARK: FavUnfvModal convenience initializers and mutators

extension FavUnfvModal {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(FavUnfvModal.self, from: data)
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

