//
//  CompanyOffersModel.swift
//  AL-HHALIL
//
//  Created by Sayed Abdo on 9/16/20.
//  Copyright © 2020 Sayed Abdo. All rights reserved.
//

import Foundation

// MARK: - Welcome
struct CompanyOffersModel: Codable {
    let status: Int?
    let msg, arMsg: String?
    let data: [CompanyOffersModelDatum]?

    enum CodingKeys: String, CodingKey {
        case status, msg
        case arMsg = "ar_msg"
        case data
    }
}

// MARK: - Datum
struct CompanyOffersModelDatum: Codable {
    let id, comName, catID, percent: String?
    let projectName, projectPhone, img, categoryName: String?

    enum CodingKeys: String, CodingKey {
        case id
        case comName = "com_name"
        case catID = "cat_id"
        case percent
        case projectName = "project_name"
        case projectPhone = "project_phone"
        case img, categoryName
    }
}


