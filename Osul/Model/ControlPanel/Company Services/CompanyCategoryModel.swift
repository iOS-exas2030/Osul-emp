//
//  CompanyCategoryModel.swift
//  AL-HHALIL
//
//  Created by Sayed Abdo on 12/1/20.
//  Copyright © 2020 Sayed Abdo. All rights reserved.
//

import Foundation

// MARK: - Welcome
struct CompanyCategoryModel: Codable {
    let status: Int?
    let msg, arMsg: String?
    let data: [CompanyCategoryModelDatum]?

    enum CodingKeys: String, CodingKey {
        case status, msg
        case arMsg = "ar_msg"
        case data
    }
}

// MARK: - Datum
struct CompanyCategoryModelDatum: Codable {
    let id, name: String?
}

