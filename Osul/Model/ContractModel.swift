//
//  ContractModel.swift
//  AL-HHALIL
//
//  Created by Sayed Abdo on 7/3/20.
//  Copyright © 2020 Sayed Abdo. All rights reserved.
//

import UIKit
class Contract : NSObject{
    var dateCreated = ""
    var clientName  = ""
    var projectType = ""
    
    init(dateCreated : String , clientName : String ,projectType : String){
        
        self.dateCreated = dateCreated
        self.clientName = clientName
        self.projectType = projectType
    }
}

