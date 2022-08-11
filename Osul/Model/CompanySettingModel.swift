// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let companySettingModel = try? newJSONDecoder().decode(CompanySettingModel.self, from: jsonData)

import Foundation

// MARK: - CompanySettingModel
struct CompanySettingModel: Codable {
    let status: Int?
    let msg, arMsg: String?
    let data: [CompanySettingModelDatum]?

    enum CodingKeys: String, CodingKey {
        case status, msg
        case arMsg = "ar_msg"
        case data
    }
}

// MARK: - Datum
struct CompanySettingModelDatum: Codable {
    let id, title, datumDescription, logo: String?
    let phone1, phone2, address1, address2: String?
    let email1, email2, website, twitter: String?
    let instagram, snapchat, facebook: String?

    enum CodingKeys: String, CodingKey {
        case id, title
        case datumDescription = "description"
        case logo, phone1, phone2, address1, address2, email1, email2, website, twitter, instagram, snapchat, facebook
    }
}
