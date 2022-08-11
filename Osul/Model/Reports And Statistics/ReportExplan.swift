//
//  ReportExplan.swift
//  AL-HHALIL
//
//  Created by Sayed Abdo on 9/21/20.
//  Copyright © 2020 Sayed Abdo. All rights reserved.
//

import Foundation

// MARK: - Welcome
struct ReportExplan: Codable {
    let status: Int?
    let msg, arMsg: String?
    let data: [ReportExplanDatum]?
    let config: Config?

    enum CodingKeys: String, CodingKey {
        case status, msg
        case arMsg = "ar_msg"
        case data, config
    }
}

// MARK: - Datum
struct ReportExplanDatum: Codable {
    let id: String?
    let title, comments: String?
    let date, time, empID: String?
    let empName: String?
    let projectID: String?
    let projectName: String?

    enum CodingKeys: String, CodingKey {
        case id, title, comments, date, time
        case empID = "emp_id"
        case empName = "emp_name"
        case projectID = "project_id"
        case projectName
    }
}
