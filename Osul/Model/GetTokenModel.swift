//
//  GetTokenModel.swift
//  AL-HHALIL
//
//  Created by Sayed Abdo on 1/11/21.
//  Copyright © 2021 Sayed Abdo. All rights reserved.
//

import Foundation

// MARK: - Welcome
struct GetTokenModel: Codable {
    let status: Int?
    let msg, arMsg, token: String?

    enum CodingKeys: String, CodingKey {
        case status, msg
        case arMsg = "ar_msg"
        case token
    }
}
