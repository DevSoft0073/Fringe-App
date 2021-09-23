//
//  FeedbackDetailModal.swift
//  Fringe
//
//  Created by MyMac on 9/23/21.
//

import Foundation

// MARK: - FeedbackDetailModal
struct FeedbackDetailModal: Codable {
    var ratingID, userID, rating, review: String?
    var golfID, createdAt, isRating: String?

    enum CodingKeys: String, CodingKey {
        case ratingID = "rating_id"
        case userID = "user_id"
        case rating, review
        case golfID = "golf_id"
        case createdAt = "created_at"
        case isRating = "is_rating"
    }
}

// MARK: FeedbackDetailModal convenience initializers and mutators

extension FeedbackDetailModal {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(FeedbackDetailModal.self, from: data)
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

