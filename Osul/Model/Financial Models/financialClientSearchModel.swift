//
//  financialClientSearchModel.swift
//  AL-HHALIL
//
//  Created by Sayed Abdo on 9/14/20.
//  Copyright © 2020 Sayed Abdo. All rights reserved.
//



import Foundation

// MARK: - Welcome
struct financialClientSearchModel: Codable {
    let status: Int?
    let msg, arMsg: String?
    let data: [financialClientSearchModelDatum?]
    let config: Config?
    
    
    enum CodingKeys: String, CodingKey {
        case status, msg
        case arMsg = "ar_msg"
        case data, config
    }
}

// MARK: - Datum
struct financialClientSearchModelDatum: Codable {
    let proID: Int?
    let proTitle, proDate, contractTitle, contractPaid: String?
    let contractDwon: String?
    let daen: [Daen]?
    let totalDaen: String?

    enum CodingKeys: String, CodingKey {
        case proID = "pro_id"
        case proTitle = "pro_title"
        case proDate = "pro_date"
        case contractTitle = "contract_title"
        case contractPaid = "contract_paid"
        case contractDwon = "contract_dwon"
        case daen , totalDaen
    }
}

// MARK: - Daen
struct Daen: Codable {
    let id, projectID, projectName, date: String?
    let amount, details, type: String?

    enum CodingKeys: String, CodingKey {
        case id
        case projectID = "project_id"
        case projectName = "project_name"
        case date, amount, details, type
    }
}
