//
//  GetProjectsModel.swift
//  AL-HHALIL
//
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let getProjectsModel = try? newJSONDecoder().decode(GetProjectsModel.self, from: jsonData)

import Foundation

// MARK: - GetProjectsModel
struct GetProjectsModel: Codable {
    let status: Int?
    let msg, arMsg: String?
    let data: GetProjects?

    enum CodingKeys: String, CodingKey {
        case status, msg
        case arMsg = "ar_msg"
        case data
    }
}

// MARK: - DataClass
struct GetProjects: Codable {
    let projects: [Project2]?
    let date: Int?
}

// MARK: - Project
struct Project2: Codable {
    let id, name, phone, email: String?
    let services: Services?
    let country: Country?
    let state: State?
    let knowUs, projectType, area, duration: String?
    let plan, clientID, date, lat: String?
    let lng, isCustomer, isContract, isAccepted: String?
    let progress, notification, isArchive: String?

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
    }
}

enum Country: String, Codable {
    case empty = ""
    case خارجالمملكةالعربيةالسعودية = "خارج المملكة العربية السعودية"
    case داخلالمملكةالعربيةالسعودية = "داخل المملكة العربية السعودية"
}

enum Services: String, Codable {
    case empty = ""
    case تصميم = "تصميم"
    case تصميموإشراف = "تصميم و إشراف"
}

enum State: String, Codable {
    case empty = ""
    case الرياض = "الرياض"
    case المنطقةالجنوبية = "المنطقة الجنوبية"
    case المنطقةالشرقية = "المنطقة الشرقية"
    case المنطقةالشمالية = "المنطقة الشمالية"
    case المنطقةالغربية = "المنطقة الغربية"
    case خارجالسعودية = "خارج السعودية"
}
