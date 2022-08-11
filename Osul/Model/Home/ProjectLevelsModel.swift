//
//  ProjectLevelsModel.swift
//  AL-HHALIL
//
//  Created by Sayed Abdo on 8/22/20.
//  Copyright © 2020 Sayed Abdo. All rights reserved.
//

import Foundation

// MARK: - Welcome
struct ProjectLevelsModel: Codable {
    let status: Int
    let msg, arMsg: String
    let data: [ProjectLevelsModelDatum?]
    let totalPercent, lat, lng: String?

    enum CodingKeys: String, CodingKey {
        case status, msg
        case arMsg = "ar_msg"
        case data, totalPercent, lat, lng
    }
}

// MARK: - Datum
struct ProjectLevelsModelDatum: Codable {
   let id, title, percent, contractID: String?
   let type, projectID, projectContractID, progress: String?
   let levelID, notification, clientView, progressTime: String?
   let empID, autoComplete, createdBy, sort: String?
   let isRead: String?

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
       case autoComplete = "auto_complete"
       case createdBy = "created_by"
       case sort
       case isRead = "is_read"
   }

}

