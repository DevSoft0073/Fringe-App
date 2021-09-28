//
//  FavoriteListing.swift
//  Fringe
//
//  Created by MyMac on 9/3/21.
//

import Foundation

// MARK: - FavoriteListing
struct FavoriteListing: Codable , Hashable{
    var golfID: String?
    var image: String?
    var status, userID, golfCourseName, location: String?
    var price, favoriteListingDescription, golfRequest, allowLocation: String?
    var allowNotification, disable, latitude, longitude: String?
    var createdAt, rating, isFav, favID: String?
    var golfImages: [String]?

    enum CodingKeys: String, CodingKey {
        case golfID = "golf_id"
        case image, status
        case userID = "user_id"
        case golfCourseName = "golf_course_name"
        case location, price
        case favoriteListingDescription = "description"
        case golfRequest = "golf_request"
        case allowLocation = "allow_location"
        case allowNotification = "allow_notification"
        case disable
        case latitude = "Latitude"
        case longitude = "Longitude"
        case createdAt = "created_at"
        case rating, isFav
        case favID = "fav_id"
        case golfImages = "golf_images"
    }
}

// MARK: FavoriteListing convenience initializers and mutators

extension FavoriteListing {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(FavoriteListing.self, from: data)
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
