//
//  ViewPaidProjectModel.swift
//  AL-HHALIL
//
//  Created by Sayed Abdo on 8/31/20.
//  Copyright © 2020 Sayed Abdo. All rights reserved.
//

import Foundation

// MARK: - Welcome
struct ViewPaidProjectModel: Codable {
    let status: Int
    let msg, arMsg: String
    let data: [ViewPaidProjectModelDatum]

    enum CodingKeys: String, CodingKey {
        case status, msg
        case arMsg = "ar_msg"
        case data
    }
}

// MARK: - Datum
struct ViewPaidProjectModelDatum: Codable {
    let id, projectID, paid, paidDown: String
    let paidTerm: String

    enum CodingKeys: String, CodingKey {
        case id
        case projectID = "project_id"
        case paid
        case paidDown = "paid_down"
        case paidTerm = "paid_term"
    }
}

