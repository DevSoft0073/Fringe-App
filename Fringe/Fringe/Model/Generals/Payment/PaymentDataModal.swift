//
//  PaymentDataModal.swift
//  Fringe
//
//  Created by MyMac on 9/15/21.
//

import Foundation

// MARK: - PaymentDataModel
struct PaymentDataModel: Codable , Hashable {
    var cardID, brand, expMonth, expYear: String?
    var last4, cardHolderName, selected: String?

    enum CodingKeys: String, CodingKey {
        case cardID = "card_id"
        case brand
        case expMonth = "exp_month"
        case expYear = "exp_year"
        case last4
        case cardHolderName = "card_holder_name"
        case selected
    }
}

// MARK: PaymentDataModel convenience initializers and mutators

extension PaymentDataModel {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(PaymentDataModel.self, from: data)
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

