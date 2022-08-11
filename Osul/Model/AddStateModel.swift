// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let addStateModel = try? newJSONDecoder().decode(AddStateModel.self, from: jsonData)

import Foundation

// MARK: - AddStateModel
struct AddStateModel: Codable {
    let status: Int?
    let msg, arMsg: String?
    let data: [Datum1]?

    enum CodingKeys: String, CodingKey {
        case status, msg
        case arMsg = "ar_msg"
        case data
    }
}

// MARK: - Datum
struct Datum1: Codable {
    let id, title: String?
}
