//
//  Employee.swift
//  AL-HHALIL
//
//  Created by Sayed Abdo on 7/15/20.
//  Copyright © 2020 Sayed Abdo. All rights reserved.
//

import Foundation

// MARK: - Employee
struct Employee: Codable {
    let status: Int
    let msg, arMsg: String
    var data: [EmployeeDatum]
    let config: Config?

    enum CodingKeys: String, CodingKey {
        case status, msg
        case arMsg = "ar_msg"
        case data , config
    }
}

// MARK: - Datum
struct EmployeeDatum: Codable {
    let id, name, email, phone: String
    let password, jopType, usersGroup, date: String
    let branche, state, address, refCode: String
    let isActive, msg: String

    enum CodingKeys: String, CodingKey {
        case id, name, email, phone, password
        case jopType = "jop_type"
        case usersGroup = "users_group"
        case date, branche, state, address
        case refCode = "ref_code"
        case isActive = "is_active"
        case msg
    }
}
