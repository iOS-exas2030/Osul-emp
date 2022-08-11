//
//  ProjectCell.swift
//  AL-HHALIL
//
//  Created by apple on 7/6/20.
//  Copyright © 2020 Sayed Abdo. All rights reserved.
//

import UIKit
import MBCircularProgressBar
class ProjectCell: UICollectionViewCell {

    @IBOutlet weak var chatNotification: UIImageView!
    
    @IBOutlet weak var projectBorderView: UIView!
    @IBOutlet weak var projectProgress: MBCircularProgressBarView!
    @IBOutlet weak var notification: UIButton!
    @IBOutlet weak var ProjectImage: UIImageView!
    @IBOutlet weak var ProjectName: UILabel!
    @IBOutlet weak var startProjectDate: UILabel!
    
    @IBOutlet weak var projectType: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
