//
//  projectAttachmentModel.swift
//  AL-HHALIL
//
//  Created by apple on 7/15/20.
//  Copyright © 2020 Sayed Abdo. All rights reserved.
//

import UIKit

class ProjectAttachment : NSObject{
    var projectName = ""
    var achieved  = ""
    var Attatch = ""
    var employee = ""
    
    init(projectName : String , achieved : String ,Attatch : String , employee : String){
        
        self.projectName = projectName
        self.achieved = achieved
        self.Attatch = Attatch
        self.employee = employee
    }
    
}

