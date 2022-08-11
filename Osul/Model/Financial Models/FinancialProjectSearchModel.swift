//
//  FinancialProjectSearchModel.swift
//  AL-HHALIL
//
//  Created by Sayed Abdo on 9/14/20.
//  Copyright © 2020 Sayed Abdo. All rights reserved.
//

import Foundation

// MARK: - Welcome
struct FinancialProjectSearchModel: Codable {
    let status: Int?
    let msg, arMsg: String?
    let data: [FinancialProjectSearchModelDatum?]
    let config: Config?
    
    enum CodingKeys: String, CodingKey {
        case status, msg
        case arMsg = "ar_msg"
        case data, config
    }
}

// MARK: - Datum
struct FinancialProjectSearchModelDatum: Codable {
    let proID: Int?
    let proTitle, proDate, contractTitle, contractPaid: String?
    let contractDwon: String?
    let maaden, daen: [FinancialProjectSearchModelDaen]
    let totalInComes, totalOutComes: String?
    

    enum CodingKeys: String, CodingKey {
        case proID = "pro_id"
        case proTitle = "pro_title"
        case proDate = "pro_date"
        case contractTitle = "contract_title"
        case contractPaid = "contract_paid"
        case contractDwon = "contract_dwon"
        case maaden, daen , totalInComes, totalOutComes
    }
}

// MARK: - Daen
struct FinancialProjectSearchModelDaen: Codable {
    let id, projectID, projectName, date: String?
    let amount, details, type: String?

    enum CodingKeys: String, CodingKey {
        case id
        case projectID = "project_id"
        case projectName = "project_name"
        case date, amount, details, type
    }
}

