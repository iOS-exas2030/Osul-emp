//
//  ClientModel.swift
//  AL-HHALIL
//
//  Created by Sayed Abdo on 3/12/21.
//  Copyright © 2021 Sayed Abdo. All rights reserved.
//

import Foundation

// MARK: - Welcome
struct ClientModel: Codable {
    let status: Int?
    let msg, arMsg: String?
    let data: [ClientModelDatum]?

    enum CodingKeys: String, CodingKey {
        case status, msg
        case arMsg = "ar_msg"
        case data
    }
}

// MARK: - Datum
struct ClientModelDatum: Codable {
    let id, name: String?
}
