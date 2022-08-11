//
//  Levels.swift
//  AL-HHALIL
//
//  Created by Sayed Abdo on 7/22/20.
//  Copyright © 2020 Sayed Abdo. All rights reserved.
//


import Foundation
import UIKit
import MobileCoreServices

// MARK: - Welcome
struct Levels: Codable {
    let status: Int
    let msg, arMsg: String
    private(set) var data: [LevelsDatum]

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
    mutating func addItem(_ place: LevelsDatum, at index: Int) {
        data.insert(place, at: index)
    }
    
}

// MARK: - Datum
struct LevelsDatum: Codable {
    let id, title, percent, contractID: String
    let type , sort: String

    enum CodingKeys: String, CodingKey {
        case id, title, percent
        case contractID = "contract_id"
        case type,sort
    }
    
    
}

extension Levels{
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
