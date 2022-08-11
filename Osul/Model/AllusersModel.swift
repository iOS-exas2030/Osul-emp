//
//  AllusersModel.swift
//  AL-HHALIL
//
//  Created by Sayed Abdo on 11/8/20.
//  Copyright © 2020 Sayed Abdo. All rights reserved.
//

import Foundation

// MARK: - Welcome
struct AllusersModel: Codable {
    let status: Int?
    let msg, arMsg: String?
    let data: AllusersModelDataClass?

    enum CodingKeys: String, CodingKey {
        case status, msg
        case arMsg = "ar_msg"
        case data
    }
}

// MARK: - DataClass
struct AllusersModelDataClass: Codable {
    let users: [AllusersModelUser]?
}

// MARK: - User
struct AllusersModelUser: Codable {
    let id, name: String?
}
