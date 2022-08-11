//
//  ProjectTypeModel.swift
//  AL-HHALIL
//
//  Created by Sayed Abdo on 10/15/20.
//  Copyright © 2020 Sayed Abdo. All rights reserved.
//

import Foundation

// MARK: - Welcome
struct ProjectTypeModel: Codable {
    let status: Int?
    let msg, arMsg: String?
    let data: [ProjectTypeModelDatum]?

    enum CodingKeys: String, CodingKey {
        case status, msg
        case arMsg = "ar_msg"
        case data
    }
}

// MARK: - Datum
struct ProjectTypeModelDatum: Codable {
    let id, title: String?
}
