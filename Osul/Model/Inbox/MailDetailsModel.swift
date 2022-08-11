//
//  MailDetailsModel.swift
//  AL-HHALIL
//
//  Created by Sayed Abdo on 9/28/20.
//  Copyright © 2020 Sayed Abdo. All rights reserved.
//

import Foundation

// MARK: - Welcome
struct MailDetailsModel: Codable {
    let status: Int?
    let msg, arMsg: String?
    let data: MailDetailsModelDataClass?

    enum CodingKeys: String, CodingKey {
        case status, msg
        case arMsg = "ar_msg"
        case data
    }
}

// MARK: - DataClass
struct MailDetailsModelDataClass: Codable {
    let mails: [MailDetailsModelMail]?
    let files: [Attachment]?
    let replay: [MailDetailsModelMail]?
}

// MARK: - Mail
struct MailDetailsModelMail: Codable {
    let id, title, comments, date: String?
    let time, senderID, senderName, recipientID: String?
    let recipientName, projectID, levelID, levelType: String?
    let projectName, levelName, empl, bdg: String?
    let sub, view, isReplay, updatedAt: String?
    let attachments: [Attachment]?

    enum CodingKeys: String, CodingKey {
        case id, title, comments, date, time
        case senderID = "sender_id"
        case senderName = "sender_name"
        case recipientID = "recipient_id"
        case recipientName = "recipient_name"
        case projectID = "project_id"
        case levelID = "level_id"
        case levelType = "level_type"
        case projectName = "project_name"
        case levelName = "level_name"
        case empl, bdg, sub, view
        case isReplay = "is_Replay"
        case updatedAt = "updated_at"
        case attachments
    }
}

// MARK: - Attachment
struct Attachment: Codable {
    let id, mailID, file: String?

    enum CodingKeys: String, CodingKey {
        case id
        case mailID = "mail_id"
        case file
    }
}
