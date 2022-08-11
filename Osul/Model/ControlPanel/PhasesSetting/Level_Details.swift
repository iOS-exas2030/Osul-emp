//
//  Level_Details.swift
//  AL-HHALIL
//
//  Created by Sayed Abdo on 7/22/20.
//  Copyright © 2020 Sayed Abdo. All rights reserved.
//

import Foundation
import UIKit
import MobileCoreServices

// MARK: - Welcome
struct Level_Details: Codable {
    let status: Int
    let msg, arMsg: String
    var data: [Level_DetailsDatum]

    enum CodingKeys: String, CodingKey {
        case status, msg
        case arMsg = "ar_msg"
        case data
    }
    
    mutating func moveItem(at sourceIndex: Int, to destinationIndex: Int) {
        guard sourceIndex != destinationIndex else { return }
        
        let place = data[sourceIndex]
        data.remove(at: sourceIndex)
        data.insert(place, at: destinationIndex)
    }
    
    /// The method for adding a new item to the table view's data model.
    mutating func addItem(_ place: Level_DetailsDatum, at index: Int) {
        data.insert(place, at: index)
    }
}

// MARK: - Datum
struct Level_DetailsDatum: Codable {
    let id, title, levelID, percent: String
    var type, comment, isPDF , questionType,clientView: String
    let state: String
    var values, pdf: [String]
    

    enum CodingKeys: String, CodingKey {
        case id, title
        case levelID = "level_id"
        case percent, type, pdf, comment
        case isPDF = "is_pdf"
        case state
        case questionType = "question_type"
        case values = "values"
        case clientView = "client_view"
    }
}
extension Level_Details{
    /**
         A helper function that serves as an interface to the data model,
         called by the implementation of the `tableView(_ canHandle:)` method.
    */
    func canHandle(_ session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: NSString.self)
    }
    
    /**
         A helper function that serves as an interface to the data mode, called
         by the `tableView(_:itemsForBeginning:at:)` method.
    */
    func dragItems(for indexPath: IndexPath) -> [UIDragItem] {
        let LevelsDatumData = data[indexPath.row]

        let data = LevelsDatumData.id.data(using: .utf8)
        let itemProvider = NSItemProvider()
        
        itemProvider.registerDataRepresentation(forTypeIdentifier: kUTTypePlainText as String, visibility: .all) { completion in
            completion(data, nil)
            return nil
        }

        return [UIDragItem(itemProvider: itemProvider)]
    }
}
