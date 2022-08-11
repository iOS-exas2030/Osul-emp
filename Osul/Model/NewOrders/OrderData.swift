//
//  OrderData.swift
//  AL-HHALIL
//
//  Created by Sayed Abdo on 8/16/20.
//  Copyright © 2020 Sayed Abdo. All rights reserved.
//

import Foundation

// MARK: - Welcome
struct OrderData: Codable {
    let status: Int
    let msg, arMsg: String
    let data: [OrderDataDatum]
    let config: Config?
    
    enum CodingKeys: String, CodingKey {
        case status, msg
        case arMsg = "ar_msg"
        case data, config
    }
}

// MARK: - Datum
struct OrderDataDatum: Codable {
    let project: [OrderDataProject]
    let contract: [OrderDataContract]
    let explan: [ExplanationModelDatum]
}

// MARK: - Contract
struct OrderDataContract: Codable {
    let id, projectID, contractID, title: String
    let price, template, pdf, color: String

    enum CodingKeys: String, CodingKey {
        case id
        case projectID = "project_id"
        case contractID = "contract_id"
        case title, price, template, pdf, color
    }
}
// MARK: - Explan
struct OrderDataExplan: Codable {
    let id, title, comments, date: String
    let time, empID: String
    let empName: String
    let projectID: String

    enum CodingKeys: String, CodingKey {
        case id, title, comments, date, time
        case empID = "emp_id"
        case empName = "emp_name"
        case projectID = "project_id"
    }
}

// MARK: - Project
struct OrderDataProject: Codable {
    let id, name, phone, email: String
    let services, country, state, knowUs: String
    let projectType, area, duration, plan: String
    let clientID, date, lat, lng: String
    let isCustomer, isContract, isAccepted: String
    let view, estbianType: String?
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
        case view
        case estbianType = "estbian_type"
    }
}
// MARK: - Datum
struct ExplanationNewOrdersModelDatum: Codable {
    let id, title, comments, date: String
    let time, empID: String
    let empName: String
    let projectID: String

    enum CodingKeys: String, CodingKey {
        case id, title, comments, date, time
        case empID = "emp_id"
        case empName = "emp_name"
        case projectID = "project_id"
    }
}
