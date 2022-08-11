//
//  MyProjectModel.swift
//  AL-HHALIL
//
//  Created by Sayed Abdo on 7/4/20.
//  Copyright © 2020 Sayed Abdo. All rights reserved.
//

import Foundation
import UIKit
class Project : NSObject{
    var notificationNumber = ""
    var projectName  = ""
    var ProjectImage = ""
    var percent = 0.0
    
    init(notificationNumber : String , projectName : String ,ProjectImage : String,percent : Double ){
        
        self.notificationNumber = notificationNumber
        self.projectName = projectName
        self.ProjectImage = ProjectImage
        self.percent = percent
    }
}
class ProjectPhase : NSObject{
    var notificationNumber = ""
    var projectPhaseName  = ""
    var percentOfPhase = 0.0
    
    init(notificationNumber : String , projectPhaseName : String ,percentOfPhase : Double ){
        
        self.notificationNumber = notificationNumber
        self.projectPhaseName = projectPhaseName
        self.percentOfPhase = percentOfPhase
    }
}
