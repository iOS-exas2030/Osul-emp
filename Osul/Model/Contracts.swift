//
//  Contracts.swift
//  AL-HHALIL
//
//  Created by Sayed Abdo on 7/22/20.
//  Copyright © 2020 Sayed Abdo. All rights reserved.
//

import Foundation

// MARK: - Welcome
struct Contracts: Codable {
    let status: Int
    let msg, arMsg: String
    let data: [ContractsDatum]
    

    enum CodingKeys: String, CodingKey {
        case status, msg
        case arMsg = "ar_msg"
        case data
    }
}

// MARK: - Datum
struct ContractsDatum: Codable {
    let id, title, price, template: String
    let pdf, color: String
}
