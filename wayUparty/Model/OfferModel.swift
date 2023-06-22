//
//  OfferModel.swift
//  wayUparty
//
//  Created by Arun on 11/04/23.
//  Copyright © 2023 Jasty Saran . All rights reserved.
//

import Foundation

struct OfferModel: Codable {
    let data: [Datum]
    let response: String
    let responseMessage: JSONNull?
    let recordsTotal, recordsFiltered: Int
    let razorpayKeyID, razorpayKeySecretID: String

    enum CodingKeys: String, CodingKey {
        case data, response, responseMessage, recordsTotal, recordsFiltered
        case razorpayKeyID = "razorpayKeyId"
        case razorpayKeySecretID = "razorpayKeySecretId"
    }
}

// MARK: - Datum
struct Datum: Codable {
    let categoryID: Int
    let categoryName, categoryUUID: String

    enum CodingKeys: String, CodingKey {
        case categoryID = "categoryId"
        case categoryName, categoryUUID
    }
}


class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
