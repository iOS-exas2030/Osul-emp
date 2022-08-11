//
//  ChatSendModel.swift
//  AL-HHALIL

struct ChatSendModel: Codable {
    let status: Int?
    let msg, arMsg: String?
    let data: ChatSendModelDataClass?

    enum CodingKeys: String, CodingKey {
        case status, msg
        case arMsg = "ar_msg"
        case data
    }
}

// MARK: - DataClass
struct ChatSendModelDataClass: Codable {
    let id, senderID, senderName, type: String?
    let message: String?
    let projectName: String?
    let projectID, levelID: String?
    let levelName: String?
    let file, createdAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case senderID = "sender_id"
        case senderName = "sender_name"
        case type, message
        case projectName = "project_name"
        case projectID = "project_id"
        case levelID = "level_id"
        case levelName = "level_name"
        case file
        case createdAt = "created_at"
    }
}

