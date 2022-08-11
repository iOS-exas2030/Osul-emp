//
//  ImagesModel.swift
//  AL-HHALIL
//
//  Created by Sayed Abdo on 7/25/20.
//  Copyright © 2020 Sayed Abdo. All rights reserved.
//

import Foundation

// MARK: - Welcome
struct ImagesModel: Codable {
    let status: Int
    let msg, arMsg: String
    let data: [ImagesModelDatum]

    enum CodingKeys: String, CodingKey {
        case status, msg
        case arMsg = "ar_msg"
        case data
    }
}

// MARK: - Datum
struct ImagesModelDatum: Codable {
    let imgfile: String
}

