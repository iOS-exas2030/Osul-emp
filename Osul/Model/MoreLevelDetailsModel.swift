//
//  MoreLevelDetailsModel.swift
//  AL-HHALIL
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let moreLevelDetailsModel = try? newJSONDecoder().decode(MoreLevelDetailsModel.self, from: jsonData)

//import Foundation

// MARK: - MoreLevelDetailsModel
struct MoreLevelDetailsModel1: Codable {
    let status: Int?
    let msg, arMsg: String?
    var data: Details1?

    enum CodingKeys: String, CodingKey {
        case status, msg
        case arMsg = "ar_msg"
        case data
    }
}

// MARK: - DataClass
struct Details1: Codable {
    let id, title, percent, levelID: String?
    let type, projectID: String?
    var pdf: [JSONAny]?
    let comment, isPDF, state: String?
    let values: [String]?
    let questionType, answer, empID, date: String?
    let clientView, sort: String?

    enum CodingKeys: String, CodingKey {
        case id, title, percent
        case levelID = "level_id"
        case type
        case projectID = "project_id"
        case pdf, comment
        case isPDF = "is_pdf"
        case state, values
        case questionType = "question_type"
        case answer
        case empID = "emp_id"
        case date
        case clientView = "client_view"
        case sort
    }
}
import Foundation

// MARK: - Welcome
struct MoreLevelDetailsModel: Codable {
    let status: Int?
    let msg, arMsg: String?
    var data: Details?

    enum CodingKeys: String, CodingKey {
        case status, msg
        case arMsg = "ar_msg"
        case data
    }
}

// MARK: - DataClass
struct Details: Codable {
    let id, title, percent, levelID: String?
    let type, projectID: String?
    var pdf : [String]?
    let comment, isPDF, state: String?
    let values: [String]?
    let questionType, answer, empID, date: String?
    let clientView, sort, img: String?

    enum CodingKeys: String, CodingKey {
        case id, title, percent
        case levelID = "level_id"
        case type
        case projectID = "project_id"
        case pdf, comment
        case isPDF = "is_pdf"
        case state, values
        case questionType = "question_type"
        case answer
        case empID = "emp_id"
        case date
        case clientView = "client_view"
        case sort , img
    }
}
