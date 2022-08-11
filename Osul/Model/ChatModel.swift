//
//  ChatModel.swift
//  AL-HHALIL
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let chatModel = try? newJSONDecoder().decode(ChatModel.self, from: jsonData)

import Foundation

// MARK: - ChatModel
struct ChatModel: Codable {
    let status: Int?
    let msg, arMsg: String?
    let data: [ChatModelDatum]?
    let config: ChatModelConfig?

    enum CodingKeys: String, CodingKey {
        case status, msg
        case arMsg = "ar_msg"
        case data, config
    }
}

// MARK: - Config
struct ChatModelConfig: Codable {
    let baseURL: String?
    let perPage, totalRows, numLinks: Int?

    enum CodingKeys: String, CodingKey {
        case baseURL = "base_url"
        case perPage = "per_page"
        case totalRows = "total_rows"
        case numLinks = "num_links"
    }
}

// MARK: - Datum
struct ChatModelDatum: Codable {
    let id, senderID: String?
    let senderName: String?
    let type, message, projectID, levelID: String?
    let file: String?
    let createdAt: String?
    

    enum CodingKeys: String, CodingKey {
        case id
        case senderID = "sender_id"
        case senderName = "sender_name"
        case type, message
        case projectID = "project_id"
        case levelID = "level_id"
        case file
        case createdAt = "created_at"
        
    }
}

enum CreatedAt: String, Codable {
    case the20201220000000 = "2020-12-20 00:00:00"
}


