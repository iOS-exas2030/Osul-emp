//
//  TotalPaidProjectModel.swift
//  AL-HHALIL
//
//  Created by Sayed Abdo on 10/15/20.
//  Copyright © 2020 Sayed Abdo. All rights reserved.
//


import Foundation

// MARK: - Welcome
struct TotalPaidProjectModel: Codable {
    let status: Int?
    let msg, arMsg: String?
    let data: [TotalPaidProjectModelDatum]?

    enum CodingKeys: String, CodingKey {
        case status, msg
        case arMsg = "ar_msg"
        case data
    }
}

// MARK: - Datum
struct TotalPaidProjectModelDatum: Codable {
    let id, projectID, paid: String?
    let paidDown, paidTerm: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case projectID = "project_id"
        case paid
        case paidDown = "paid_down"
        case paidTerm = "paid_term"
    }
}

