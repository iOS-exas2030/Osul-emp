//
//  PaginationConfig.swift
//  AL-HHALIL
//
//  Created by Sayed Abdo on 10/26/20.
//  Copyright © 2020 Sayed Abdo. All rights reserved.
//

import Foundation


// MARK: - Config
struct Config: Codable {
    let baseURL: String?
    let perPage, totalRows, numLinks: Int?

    enum CodingKeys: String, CodingKey {
        case baseURL = "base_url"
        case perPage = "per_page"
        case totalRows = "total_rows"
        case numLinks = "num_links"
    }
}
