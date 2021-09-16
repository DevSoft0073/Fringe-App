//
//  AddCardDataModal.swift
//  Fringe
//
//  Created by MyMac on 9/15/21.
//

import Foundation

// MARK: - AddCardDataModal
struct AddCardDataModal: Codable {
    var id, userID, creationAt, cardID: String?
    var object, brand, country, customer: String?
    var cvcCheck, expMonth, expYear, funding: String?
    var last4, name, selected: String?

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case creationAt = "creation_at"
        case cardID = "card_id"
        case object, brand, country, customer
        case cvcCheck = "cvc_check"
        case expMonth = "exp_month"
        case expYear = "exp_year"
        case funding, last4, name, selected
    }
}

// MARK: AddCardDataModal convenience initializers and mutators

extension AddCardDataModal {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(AddCardDataModal.self, from: data)
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

