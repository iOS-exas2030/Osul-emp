//
//  AddLevelModel.swift
//  AL-HHALIL
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let addLevelModel = try? newJSONDecoder().decode(AddLevelModel.self, from: jsonData)

import Foundation

// MARK: - AddLevelModel
struct AddLevelModel: Codable {
    let status: Int?
    let msg, arMsg: String?
    let data: AddLevelModelDataClass?

    enum CodingKeys: String, CodingKey {
        case status, msg
        case arMsg = "ar_msg"
        case data
    }
}

// MARK: - DataClass
struct AddLevelModelDataClass: Codable {
    let id, title, percent, contractID: String?
    let type, projectID, projectContractID, progress: String?
    let levelID, notification, clientView, progressTime: String?
    let empID, createdBy, sort: String?

    enum CodingKeys: String, CodingKey {
        case id, title, percent
        case contractID = "contract_id"
        case type
        case projectID = "project_id"
        case projectContractID = "project_contract_id"
        case progress
        case levelID = "level_id"
        case notification
        case clientView = "client_view"
        case progressTime = "progress_time"
        case empID = "emp_id"
        case createdBy = "created_by"
        case sort
    }
}
