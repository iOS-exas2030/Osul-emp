//
//  AnswerQueModel.swift
//  AL-HHALIL
//
//  Created by Sayed Abdo on 9/30/20.
//  Copyright © 2020 Sayed Abdo. All rights reserved.
//

import Foundation

// MARK: - Welcome
struct AnswerQueModel: Codable {
    let status: Int
    let msg, arMsg: String
    let data: [AnswerQueModelDatum]

    enum CodingKeys: String, CodingKey {
        case status, msg
        case arMsg = "ar_msg"
        case data
    }
}

// MARK: - Datum
struct AnswerQueModelDatum: Codable {
    let id, title, percent, levelID: String
    let type, projectID, pdf, comment: String
    let isPDF, state, questionType: String
    let values: [String]?
    let answer, empID, date: String

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
    }
}
