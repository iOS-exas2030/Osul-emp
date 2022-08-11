//
//  paymentsReportsModel.swift
//  AL-HHALIL
//
//  Created by Sayed Abdo on 9/20/20.
//  Copyright © 2020 Sayed Abdo. All rights reserved.
//

import Foundation

// MARK: - Welcome
struct paymentsReportsModel: Codable {
    let status: Int
    let msg, arMsg: String
    let data: [paymentsReportsModelDatum]
    let config: Config?
    
    enum CodingKeys: String, CodingKey {
        case status, msg
        case arMsg = "ar_msg"
        case data, config
    }
}

// MARK: - Datum
struct paymentsReportsModelDatum: Codable {
    let proName, total: String
    let paid, remain: Int

    enum CodingKeys: String, CodingKey {
        case proName = "pro_name"
        case total, paid, remain
    }
}
