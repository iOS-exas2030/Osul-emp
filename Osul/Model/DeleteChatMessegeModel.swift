//
//  DeleteChatMessegeModel.swift
//  AL-HHALIL
//
//  Created by apple on 1/11/21.
//  Copyright © 2021 Sayed Abdo. All rights reserved.
//

import Foundation
struct DeleteChatMessegeModel: Codable {
    let status: Int?
    let msg, arMsg: String?
    let data: [JSONAny]?

    enum CodingKeys: String, CodingKey {
        case status, msg
        case arMsg = "ar_msg"
        case data
    }
}
