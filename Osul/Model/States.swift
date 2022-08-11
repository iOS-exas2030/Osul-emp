//
//  States.swift
//  AL-HHALIL
//
//  Created by Sayed Abdo on 7/16/20.
//  Copyright © 2020 Sayed Abdo. All rights reserved.
//

import Foundation

// MARK: - Welcome
struct States: Codable {
    let status: Int
    let msg, arMsg: String
    let data: [StatesDatum]

    enum CodingKeys: String, CodingKey {
        case status, msg
        case arMsg = "ar_msg"
        case data
    }
}

// MARK: - Datum
struct StatesDatum: Codable {
    let id, title: String
}
