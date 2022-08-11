//
//  NotificationStatus.swift
//  AL-HHALIL
//
//  Created by Sayed Abdo on 10/28/20.
//  Copyright © 2020 Sayed Abdo. All rights reserved.
//

import Foundation

// MARK: - Welcome
struct NotificationStatus: Codable {
    let status: Int?
    let msg, arMsg: String?
    let data: NotificationStatusDataClass?

    enum CodingKeys: String, CodingKey {
        case status, msg
        case arMsg = "ar_msg"
        case data
    }
}

// MARK: - DataClass
struct NotificationStatusDataClass: Codable {
    let newProjects, newContract, newMails, chat: Int?

    enum CodingKeys: String, CodingKey {
        case newProjects, newContract
        case newMails = "NewMails"
        case chat = "Chat"
    }
}
