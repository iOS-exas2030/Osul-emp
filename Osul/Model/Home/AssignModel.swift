//
//  AssignModel.swift
//  AL-HHALIL
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let assignModel = try? newJSONDecoder().decode(AssignModel.self, from: jsonData)

import Foundation

// MARK: - AssignModel
struct AssignModel: Codable {
    let status: Int?
    let msg, arMsg: String?
    var data: DataClass?

    enum CodingKeys: String, CodingKey {
        case status, msg
        case arMsg = "ar_msg"
        case data
    }
}

// MARK: - DataClass
struct DataClass: Codable {
    var assignedUsers: [AssignedUser]?
    var availableUsers: [AvailableUser]?
    let levelID, projectID: String?

    enum CodingKeys: String, CodingKey {
        case assignedUsers = "assigned_users"
        case availableUsers = "available_users"
        case levelID = "level_id"
        case projectID = "project_id"
    }
}

// MARK: - AssignedUser
struct AssignedUser: Codable {
    let id, name, jopType,permissionID: String?
    let title: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case permissionID = "permission_id"
        case jopType = "jop_type"
        case title
    }
}

// MARK: - AvailableUser
struct AvailableUser: Codable {
    let id, name, jopType: String?
    let title: String?
}
//////
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

//import Foundation
//
//// MARK: - Welcome
//struct AssignModel: Codable {
//    let status: Int?
//    let msg, arMsg: String?
//    var data: DataClass?
//
//    enum CodingKeys: String, CodingKey {
//        case status, msg
//        case arMsg = "ar_msg"
//        case data
//    }
//}
//
//// MARK: - DataClass
//struct DataClass: Codable {
//    var assignedUsers, availableUsers: [AssignedUser]?
//    let levelID, projectID: String?
//
//    enum CodingKeys: String, CodingKey {
//        case assignedUsers = "assigned_users"
//        case availableUsers = "available_users"
//        case levelID = "level_id"
//        case projectID = "project_id"
//    }
//}
//
//// MARK: - User
//struct AssignedUser: Codable {
//    let id, name, jopType, permissionID: String?
//    let title: String?
//
//    enum CodingKeys: String, CodingKey {
//        case id, name
//        case jopType = "jop_type"
//        case permissionID = "permission_id"
//        case title
//    }
//}


