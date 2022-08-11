//
//  AssignNewModel.swift
//  AL-HHALIL
//
//  Created by Sayed Abdo on 9/30/20.
//  Copyright © 2020 Sayed Abdo. All rights reserved.
//

import Foundation

// MARK: - Welcome
struct AssignNewModel: Codable {
    let status: Int
    let msg, arMsg: String
    var data: AssignNewModelDataClass

    enum CodingKeys: String, CodingKey {
        case status, msg
        case arMsg = "ar_msg"
        case data
    }
}

// MARK: - DataClass
struct AssignNewModelDataClass: Codable {
    var assignedUsers, availableUsers: [AssignNewModelUser]
    let levelID, projectID: String

    enum CodingKeys: String, CodingKey {
        case assignedUsers = "assigned_users"
        case availableUsers = "available_users"
        case levelID = "level_id"
        case projectID = "project_id"
    }
}

// MARK: - User
struct AssignNewModelUser: Codable {
    let id, name, jopType: String?
    let permissionID: String?
    let title: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case jopType = "jop_type"
        case permissionID = "permission_id"
        case title
    }
}
