//
//  assignEmployeCell.swift
//  AL-HHALIL
//
//  Created by apple on 8/27/20.
//  Copyright © 2020 Sayed Abdo. All rights reserved.
//

import UIKit

class assignEmployeCell: UITableViewCell {

    @IBOutlet weak var jobTitleLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
