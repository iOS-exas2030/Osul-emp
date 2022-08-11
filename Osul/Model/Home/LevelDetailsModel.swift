//
//  LevelDetailsModel.swift
//  AL-HHALIL
//
//  Created by Sayed Abdo on 8/22/20.
//  Copyright © 2020 Sayed Abdo. All rights reserved.
//

import Foundation

// MARK: - Welcome
struct LevelDetailsModel: Codable {
    let status: Int
    let msg, arMsg: String
    var data: [LevelDetailsModelDatum]
    let progressTime : String
    let  chatIsRead: String?

    enum CodingKeys: String, CodingKey {
        case status, msg
        case arMsg = "ar_msg"
        case data
        case progressTime = "ProgressTime"
        case chatIsRead = "chat_is_read"
    }
}

// MARK: - Datum
struct LevelDetailsModelDatum: Codable {
    let id, title, percent, levelID: String?
    let type, projectID: String?
    let pdf: [String]?
    let comment, isPDF, state: String?
    let values: [String]?
    let questionType: String?
    var answer: String?
    let empID, date: String?
    let clientView, sort : String?
    var otherAnswer: String?
    let img : String?

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
        case sort, otherAnswer
        case img
        
    }
}

enum Answer: String, Codable {
    case empty = ""
    case yesYes = "yes yes "
}
