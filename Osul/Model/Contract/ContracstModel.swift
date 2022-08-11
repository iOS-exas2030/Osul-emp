//
//  ContractModel.swift
//  
//
//  Created by Sayed Abdo on 8/16/20.
//

import Foundation

// MARK: - Welcome
struct ContractModel: Codable {
    let status: Int?
    let msg, arMsg: String?
    let data: [ContractModelDatum]?
    let config: Config?

    enum CodingKeys: String, CodingKey {
        case status, msg
        case arMsg = "ar_msg"
        case data, config
    }
}
// MARK: - Datum
struct ContractModelDatum: Codable {
    let projectID, projectName, projectDate, projectType: String?
    let projectProgress, view ,estbianType,projectPercent: String?

    enum CodingKeys: String, CodingKey {
        case projectID = "project_id"
        case projectName = "project_name"
        case projectDate = "project_date"
        case projectType = "project_type"
        case projectProgress = "project_progress"
        case view
        case estbianType = "estbian_type"
        case projectPercent = "project_percent"
    }
}
