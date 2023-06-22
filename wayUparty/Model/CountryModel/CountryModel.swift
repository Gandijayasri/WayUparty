//
//  CountryModel.swift
//  wayUparty
//
//  Created by jayasri on 18/06/23.
//  Copyright © 2023 Arun. All rights reserved.
//



import Foundation

// MARK: - CountryModel
struct CountryModel: Codable {
    let data: [CountryData]?
    let response, responseMessage: String?
    let recordsTotal, recordsFiltered: Int?
    let razorpayKeyID, razorpayKeySecretID: String?

    enum CodingKeys: String, CodingKey {
        case data, response, responseMessage, recordsTotal, recordsFiltered
        case razorpayKeyID = "razorpayKeyId"
        case razorpayKeySecretID = "razorpayKeySecretId"
    }
}

// MARK: - Datum
struct CountryData: Codable {
    let countryID: Int?
    let countryName: String?

    enum CodingKeys: String, CodingKey {
        case countryID = "countryId"
        case countryName
    }
}
