//
//  ArchiveProjectDataModel.swift
//  AL-HHALIL
//
//  Created by Sayed Abdo on 9/21/20.
//  Copyright © 2020 Sayed Abdo. All rights reserved.
//

import Foundation

// MARK: - Welcome
struct ArchiveProjectDataModel: Codable {
    let status: Int
    let msg, arMsg: String
    let data: [ArchiveProjectDataModelDatum]
    let config: Config?
    
    enum CodingKeys: String, CodingKey {
        case status, msg
        case arMsg = "ar_msg"
        case data, config
    }
}

// MARK: - Datum
struct ArchiveProjectDataModelDatum: Codable {
    let id, name, phone, email: String
    let services, country, state, knowUs: String
    let projectType, area, duration, plan: String
    let clientID, date, lat, lng: String
    let isCustomer, isContract, isAccepted, progress: String
    let notification, isArchive, projectID, contractID: String
    let title, price, template, pdf: String
    let color: String

    enum CodingKeys: String, CodingKey {
        case id, name, phone, email, services, country, state
        case knowUs = "know_us"
        case projectType = "project_type"
        case area, duration, plan
        case clientID = "client_id"
        case date, lat, lng
        case isCustomer = "is_customer"
        case isContract = "is_contract"
        case isAccepted = "is_accepted"
        case progress, notification
        case isArchive = "is_archive"
        case projectID = "project_id"
        case contractID = "contract_id"
        case title, price, template, pdf, color
    }
}
