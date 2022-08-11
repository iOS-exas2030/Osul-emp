//
//  MailCell.swift
//  AL-HHALIL
//
//  Created by apple on 7/28/20.
//  Copyright © 2020 Sayed Abdo. All rights reserved.
//

import UIKit
import SwipeCellKit

class MailCell: SwipeTableViewCell {
    
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var projectNameLabel: UIButton!
    @IBOutlet weak var statusView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
