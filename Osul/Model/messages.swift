//
//  messages.swift
//  Hermosa
//
//  Created by apple on 3/8/20.
//  Copyright © 2020 Softagi. All rights reserved.
//

import UIKit

class messages : NSObject{
    
    var isView: Bool?
    var message : String?
    var senderId : String?
    var senderName : String?
    var reciverId : String?
    var time : String?
    var messagekey : String?
    init(messageKey: String ,text: String , senderId : String, senderName: String ,reciverId: String, time : String){
        self.messagekey = messageKey
        self.message = text
        self.senderId = senderId
        self.senderName = senderName
        self.reciverId = reciverId
        self.time = time
        
    }
    
}
 
