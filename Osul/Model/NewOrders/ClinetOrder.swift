//
//  ClinetOrder.swift
//  AL-HHALIL
//
//  Created by Sayed Abdo on 8/16/20.
//  Copyright © 2020 Sayed Abdo. All rights reserved.
//

import Foundation

// MARK: - Welcome
struct ClinetOrder: Codable {
    let status: Int?
    let msg, arMsg: String?
    let data: [ClinetOrderDatum]?
    let config: Config?

    enum CodingKeys: String, CodingKey {
        case status, msg
        case arMsg = "ar_msg"
        case data, config
    }
}

// MARK: - Datum
struct ClinetOrderDatum: Codable {
    let projectID, projectName, projectDate, projectType: String?
    let view, estbianType: String?
    enum CodingKeys: String, CodingKey {
        case projectID = "project_id"
        case projectName = "project_name"
        case projectDate = "project_date"
        case projectType = "project_type"
        case view
        case estbianType = "estbian_type"
    }
}
