//
//  SMSLogsModel.swift
//  AL-HHALIL
//
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let sMSLogsModel = try? newJSONDecoder().decode(SMSLogsModel.self, from: jsonData)

import Foundation

// MARK: - SMSLogsModel
struct SMSLogsModel: Codable {
    let status: Int?
    let msg, arMsg: String?
    let data: [SMSLogsModelDatum]?
    let config: SMSLogsModelConfig?
    let smsLimit, smsUsed: Int?

    enum CodingKeys: String, CodingKey {
        case status, msg
        case arMsg = "ar_msg"
        case data, config
        case smsLimit = "sms_limit"
        case smsUsed = "sms_used"
    }
}

// MARK: - Config
struct SMSLogsModelConfig: Codable {
    let baseURL: String?
    let perPage, totalRows, numLinks: Int?

    enum CodingKeys: String, CodingKey {
        case baseURL = "base_url"
        case perPage = "per_page"
        case totalRows = "total_rows"
        case numLinks = "num_links"
    }
}

// MARK: - Datum
struct SMSLogsModelDatum: Codable {
    let id, type, userID, datumDescription: String?
    let createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, type
        case userID = "user_id"
        case datumDescription = "description"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
