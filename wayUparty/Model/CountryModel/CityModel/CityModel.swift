//
//  CityModel.swift
//  wayUparty
//
//  Created by jayasri on 18/06/23.
//  Copyright © 2023 Arun. All rights reserved.
//


import Foundation

// MARK: - CityModel
struct CityModel: Codable {
    let data: [CityData]?
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
struct CityData: Codable {
    let cityName, cityImage, latitude, longitude: String?
    let countryID: String?

    enum CodingKeys: String, CodingKey {
        case cityName, cityImage, latitude, longitude
        case countryID = "countryId"
    }
}
