//
//  FirebaseModel.swift
//  ALKhalil_Client
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let firebaseModel = try? newJSONDecoder().decode(FirebaseModel.self, from: jsonData)

import Foundation

// MARK: - FirebaseModel
struct FirebaseModel: Codable {
    let status: Int?
    let msg, arMsg: String?
    let data: [FirebaseModelDatum]?

    enum CodingKeys: String, CodingKey {
        case status, msg
        case arMsg = "ar_msg"
        case data
    }
}

// MARK: - Datum
struct FirebaseModelDatum: Codable {
    let id, name, email, phone: String?
    let password, usersGroup, date, branche: String?
    let state, address, refCode, isActive: String?
    let firebaseType, tokenID, msg: String?

    enum CodingKeys: String, CodingKey {
        case id, name, email, phone, password
        case usersGroup = "users_group"
        case date, branche, state, address
        case refCode = "ref_code"
        case isActive = "is_active"
        case firebaseType = "firebase_type"
        case tokenID = "token_id"
        case msg
    }
}
