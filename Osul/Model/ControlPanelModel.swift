//
//  ControlPanelModel.swift
//  AL-HHALIL
//
//  Created by Sayed Abdo on 7/3/20.
//  Copyright © 2020 Sayed Abdo. All rights reserved.
//

import UIKit
class ControlPanel : NSObject{
    var imageName = ""
    var departmentName  = ""
    
    init(imageName : String , departmentName : String ){
        
        self.imageName = imageName
        self.departmentName = departmentName
    }
}
