//
//  FollowReportCell.swift
//  AL-HHALIL
//
//  Created by Sayed Abdo on 8/27/20.
//  Copyright © 2020 Sayed Abdo. All rights reserved.
//

import UIKit

class FollowReportCell: UITableViewCell {

    
    
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var clientName: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var projectType: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
