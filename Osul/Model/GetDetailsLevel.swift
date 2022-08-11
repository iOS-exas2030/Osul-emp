//
//  GetDetails.swift
//  AL-HHALIL
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let getDetailsLevel = try? newJSONDecoder().decode(GetDetailsLevel.self, from: jsonData)

import Foundation

// MARK: - GetDetailsLevel
struct GetDetailsLevel: Codable {
    let status: Int?
    let msg, arMsg: String?
    var data: DataClass3?

    enum CodingKeys: String, CodingKey {
        case status, msg
        case arMsg = "ar_msg"
        case data
    }
}

// MARK: - DataClass
struct DataClass3: Codable {
    let id, title, levelID, percent: String?
    let type: String?
    let pdf: [String]?
    let comment, isPDF, state: String?
    var values: [String]?
    let questionType: String?

    enum CodingKeys: String, CodingKey {
        case id, title
        case levelID = "level_id"
        case percent, type, pdf, comment
        case isPDF = "is_pdf"
        case state, values
        case questionType = "question_type"
    }
}
