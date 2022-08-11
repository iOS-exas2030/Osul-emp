//
//  OneMailBoxModel.swift
//  AL-HHALIL
//
//  Created by Sayed Abdo on 8/27/20.
//  Copyright © 2020 Sayed Abdo. All rights reserved.
//

import Foundation

// MARK: - Welcome
struct OneMailBoxModel: Codable {
    let status: Int?
    let msg, arMsg: String?
    let data: OneMailBoxModelDataClass?

    enum CodingKeys: String, CodingKey {
        case status, msg
        case arMsg = "ar_msg"
        case data
    }
}

// MARK: - DataClass
struct OneMailBoxModelDataClass: Codable {
    let id, title, comments, date: String?
    let time, senderID, senderName, recipientID: String?
    let recipientName, projectID, projectName, levelName: String?
    let empl, bdg: String?
    let files: [File?]

    enum CodingKeys: String, CodingKey {
        case id, title, comments, date, time
        case senderID = "sender_id"
        case senderName = "sender_name"
        case recipientID = "recipient_id"
        case recipientName = "recipient_name"
        case projectID = "project_id"
        case projectName = "project_name"
        case levelName = "level_name"
        case empl, bdg, files
    }
}
struct File: Codable {
    let id, mailID: String?
    let file: String?

    enum CodingKeys: String, CodingKey {
        case id
        case mailID = "mail_id"
        case file
    }
}
