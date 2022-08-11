//
//  ReportCurrectProjectCell.swift
//  AL-HHALIL
//
//  Created by Sayed Abdo on 8/27/20.
//  Copyright © 2020 Sayed Abdo. All rights reserved.
//

import UIKit
import MBCircularProgressBar

class ArchiveProjectsCell: UITableViewCell {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var projectNameLabel: UILabel!
    @IBOutlet weak var projectTypeLabel: UILabel!
    @IBOutlet weak var projectProgress: MBCircularProgressBarView!
    @IBOutlet weak var projectStatus: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
