//
//  UserGroup.swift
//  AL-HHALIL
//
//  Created by Sayed Abdo on 7/16/20.
//  Copyright © 2020 Sayed Abdo. All rights reserved.
//

import Foundation

// MARK: - Welcome
struct UserGroup: Codable {
    let status: Int
    let msg, arMsg: String
    var data: [UserGroupDatum]

    enum CodingKeys: String, CodingKey {
        case status, msg
        case arMsg = "ar_msg"
        case data
    }
}

// MARK: - Datum
struct UserGroupDatum: Codable {
    var id, title, type, isClientOrder: String
    var isContracting, isProjects, isReport, isFinancial: String
    var isSettings, isProgressTime: String

    enum CodingKeys: String, CodingKey {
        case id, title, type
        case isClientOrder = "is_client_order"
        case isContracting = "is_contracting"
        case isProjects = "is_projects"
        case isReport = "is_report"
        case isFinancial = "is_financial"
        case isSettings = "is_settings"
        case isProgressTime = "is_progressTime"
    }
}
