//
//  AdvanceSearchModel.swift
//  AL-HHALIL
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let advanceSearchModel = try? newJSONDecoder().decode(AdvanceSearchModel.self, from: jsonData)

import Foundation

// MARK: - AdvanceSearchModel
struct AdvanceSearchModel: Codable {
    let status: Int?
    let msg, arMsg: String?
    let data: [AdvanceSearchModelDatum]?

    enum CodingKeys: String, CodingKey {
        case status, msg
        case arMsg = "ar_msg"
        case data
    }
}

// MARK: - Datum
struct AdvanceSearchModelDatum: Codable {
    let id, name, phone, email: String?
    let services, country, state, knowUs: String?
    let projectType, area, duration, plan: String?
    let clientID, date, lat, lng: String?
    let isCustomer, isContract, isAccepted, acceptDate: String?
    let confirm, confirmDate, progress, notification: String?
    let isArchive: String?
    let archiveDate: JSONNull5?
    let view, estbianType, color: String?

    enum CodingKeys: String, CodingKey {
        case id, name, phone, email, services, country, state
        case knowUs = "know_us"
        case projectType = "project_type"
        case area, duration, plan
        case clientID = "client_id"
        case date, lat, lng
        case isCustomer = "is_customer"
        case isContract = "is_contract"
        case isAccepted = "is_accepted"
        case acceptDate = "accept_date"
        case confirm
        case confirmDate = "confirm_date"
        case progress, notification
        case isArchive = "is_archive"
        case archiveDate = "archive_date"
        case view
        case estbianType = "estbian_type"
        case color
    }
}

// MARK: - Encode/decode helpers

class JSONNull5: Codable, Hashable {

    public static func == (lhs: JSONNull5, rhs: JSONNull5) -> Bool {
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
