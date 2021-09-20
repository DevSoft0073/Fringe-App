//
//  CheckModal.swift
//  Fringe
//
//  Created by MyMac on 9/9/21.
//

import Foundation

// MARK: - CheckModal
struct CheckModal: Codable, Hashable {
    var golfID, image, status, userID: String?
    var golfCourseName, location, price, checkModalDescription: String?
    var golfRequest, allowLocation, allowNotification, disable: String?
    var latitude, longitude, createdAt, date: String?

    enum CodingKeys: String, CodingKey {
        case golfID = "golf_id"
        case image, status
        case userID = "user_id"
        case golfCourseName = "golf_course_name"
        case location, price
        case checkModalDescription = "description"
        case golfRequest = "golf_request"
        case allowLocation = "allow_location"
        case allowNotification = "allow_notification"
        case disable
        case latitude = "Latitude"
        case longitude = "Longitude"
        case createdAt = "created_at"
        case date
    }
}

// MARK: CheckModal convenience initializers and mutators

extension CheckModal {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(CheckModal.self, from: data)
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

