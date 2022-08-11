//
//  Client.swift
//  AL-HHALIL
//
//  Created by Sayed Abdo on 7/16/20.
//  Copyright © 2020 Sayed Abdo. All rights reserved.
//

import Foundation

// MARK: - Welcome
struct Client: Codable {
    let status: Int
    let msg, arMsg: String
    let data: [ClientDatum]
    let config: Config?

    enum CodingKeys: String, CodingKey {
        case status, msg
        case arMsg = "ar_msg"
        case data, config
    }
}

// MARK: - Datum
struct ClientDatum: Codable {
    let id, name, email, phone: String
    let password, usersGroup, date, branche: String
    let state, address, refCode, isActive: String
    let msg: String

    enum CodingKeys: String, CodingKey {
        case id, name, email, phone, password
        case usersGroup = "users_group"
        case date, branche, state, address
        case refCode = "ref_code"
        case isActive = "is_active"
        case msg
    }
}
