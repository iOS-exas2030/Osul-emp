//
//  interiorCell.swift
//  AL-HHALIL
//
//  Created by apple on 8/23/20.
//  Copyright © 2020 Sayed Abdo. All rights reserved.
//

import UIKit

class interiorCell: UITableViewCell {

    @IBOutlet weak var achievementButton: UIButton!
    @IBOutlet weak var dateTF: UILabel!
    @IBOutlet weak var nameTF: UILabel!
    @IBOutlet weak var attachmentButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
