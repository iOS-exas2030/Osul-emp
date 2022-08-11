//
//  ReportTasksCell.swift
//  AL-HHALIL
//
//  Created by Sayed Abdo on 10/7/20.
//  Copyright © 2020 Sayed Abdo. All rights reserved.
//

import UIKit

class ReportTasksCell: UITableViewCell {

    
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var operationNameLabel: UILabel!
    @IBOutlet weak var projectNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
