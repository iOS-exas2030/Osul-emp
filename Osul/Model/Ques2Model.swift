//
//  Ques2Model.swift
//  AL-HHALIL
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let ques2Model = try? newJSONDecoder().decode(Ques2Model.self, from: jsonData)

import Foundation

// MARK: - Ques2Model
struct Ques2Model: Codable {
    let status: Int?
    let msg, arMsg: String?
    let data: [Ques2ModelDatum]?

    enum CodingKeys: String, CodingKey {
        case status, msg
        case arMsg = "ar_msg"
        case data
    }
}

// MARK: - Datum
struct Ques2ModelDatum: Codable {
    let id, title, percent, levelID: String?
    let type, projectID, pdf, comment: String?
    let isPDF, state, values, questionType: String?
    let answer, otherAnswer, empID, date: String?
    let clientView, sort: String?
    let img: String?

    enum CodingKeys: String, CodingKey {
        case id, title, percent
        case levelID = "level_id"
        case type
        case projectID = "project_id"
        case pdf, comment
        case isPDF = "is_pdf"
        case state, values
        case questionType = "question_type"
        case answer, otherAnswer
        case empID = "emp_id"
        case date
        case clientView = "client_view"
        case sort, img
    }
}
