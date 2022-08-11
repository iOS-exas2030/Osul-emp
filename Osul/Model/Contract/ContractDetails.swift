//
//  ContractDetails.swift
//  AL-HHALIL
//
//  Created by Sayed Abdo on 8/16/20.
//  Copyright © 2020 Sayed Abdo. All rights reserved.
//

import Foundation

// MARK: - Welcome
struct ContractDetails: Codable {
    let status: Int
    let msg, arMsg: String
    let data: [contractDetailsDatum]

    enum CodingKeys: String, CodingKey {
        case status, msg
        case arMsg = "ar_msg"
        case data
    }
}

// MARK: - Datum
struct contractDetailsDatum: Codable {
    let project: [contractDetailsProject]
    let contract: [contractDetailsContract]
}

// MARK: - Contract
struct contractDetailsContract: Codable {
    let id, projectID, contractID, title: String
    let price, template, pdf, color: String

    enum CodingKeys: String, CodingKey {
        case id
        case projectID = "project_id"
        case contractID = "contract_id"
        case title, price, template, pdf, color
    }
}

// MARK: - Project
struct contractDetailsProject: Codable {
    let id, name, phone, email: String?
    let services, country, state, knowUs: String?
    let projectType, area, duration, plan: String?
    let clientID, date, lat, lng: String?
    let isCustomer, isContract, isAccepted, acceptDate: String?
    let confirm, confirmDate, progress, percent: String?
    let notification, isArchive: String?
    let archiveDate: String?
    let view, estbianType, financialType, templateType: String?
    let priceType: String?
    let createdBy: String?
    let isCreated: String?

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
        case acceptDate = "accept_date"
        case confirm
        case confirmDate = "confirm_date"
        case progress, percent, notification
        case isArchive = "is_archive"
        case archiveDate = "archive_date"
        case view
        case estbianType = "estbian_type"
        case financialType = "financial_type"
        case templateType = "template_type"
        case priceType = "price_type"
        case createdBy = "created_by"
        case isCreated = "is_created"
    }}
