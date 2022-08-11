// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let loginModel = try? newJSONDecoder().decode(LoginModel.self, from: jsonData)

import Foundation

// MARK: - LoginModel
struct LoginModel: Codable {
    let status: Int?
    let msg, arMsg: String?
    let data: [Datum3]?

    enum CodingKeys: String, CodingKey {
        case status, msg
        case arMsg = "ar_msg"
        case data
    }
}

// MARK: - Datum
struct Datum3: Codable {
    let userDetails: [UserDetail]?
    let userGroup: [Group]?

    enum CodingKeys: String, CodingKey {
        case userDetails = "user_details"
        case userGroup = "user_group"
    }
}

struct tokenModel: Codable {
    let status: Int?
    let msg, arMsg: String?
    let data:[UserDetail]?

    enum CodingKeys: String, CodingKey {
        case status, msg
        case arMsg = "ar_msg"
        case data
    }
}

// MARK: - UserDetail
struct UserDetail: Codable {
    let id, name, email, phone: String?
    let password, jopType, usersGroup, date: String?
    let branche, state, address, isActive , firebase: String?

    enum CodingKeys: String, CodingKey {
        case id, name, email, phone, password
        case jopType = "jop_type"
        case usersGroup = "users_group"
        case date, branche, state, address
        case isActive = "is_active"
        case firebase = "firebase_type"
    }
}
// MARK: - UserGroup
struct Group: Codable {
    let id, title, type, isClientOrder: String?
    let isContracting, isProjects, isReport, isFinancial: String?
    let isSettings,isProgressTime: String?

    enum CodingKeys: String, CodingKey {
        case id, title, type
        case isClientOrder = "is_client_order"
        case isContracting = "is_contracting"
        case isProjects = "is_projects"
        case isReport = "is_report"
        case isFinancial = "is_financial"
        case isSettings = "is_settings"
        case isProgressTime = "is_progressTime"
    }
}
