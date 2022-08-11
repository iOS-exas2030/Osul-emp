//
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let changePasswordModel = try? newJSONDecoder().decode(ChangePasswordModel.self, from: jsonData)

import Foundation

// MARK: - ChangePasswordModel
struct ChangePasswordModel: Codable {
    let status: Int?
    let msg, arMsg: String?
    let data: [Datum4]?

    enum CodingKeys: String, CodingKey {
        case status, msg
        case arMsg = "ar_msg"
        case data
    }
}

// MARK: - Datum
struct Datum4: Codable {
    let id, name, email, phone: String?
    let password, jopType, usersGroup, date: String?
    let branche, state, address, isActive: String?

    enum CodingKeys: String, CodingKey {
        case id, name, email, phone, password
        case jopType = "jop_type"
        case usersGroup = "users_group"
        case date, branche, state, address
        case isActive = "is_active"
    }
}
