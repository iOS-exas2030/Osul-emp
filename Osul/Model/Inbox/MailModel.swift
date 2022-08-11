//
//  MailModel.swift
//  AL-HHALIL
//
//  Created by Sayed Abdo on 8/26/20.
//  Copyright © 2020 Sayed Abdo. All rights reserved.
//

import Foundation

// MARK: - Welcome
struct MailModel: Codable {
    let status: Int
    let msg, arMsg: String
    let data: [MailModelDatum]
    let config: Config?

    enum CodingKeys: String, CodingKey {
        case status, msg
        case arMsg = "ar_msg"
        case data, config
    }
}

// MARK: - Datum
struct MailModelDatum: Codable {
    let id, title, comments, date: String
    let time, senderID, senderName, recipientID: String
    let recipientName, projectID, projectName, levelName: String
    let empl, bdg,view: String

    enum CodingKeys: String, CodingKey {
        case id, title, comments, date, time
        case senderID = "sender_id"
        case senderName = "sender_name"
        case recipientID = "recipient_id"
        case recipientName = "recipient_name"
        case projectID = "project_id"
        case projectName = "project_name"
        case levelName = "level_name"
        case empl, bdg ,view
    }
}
