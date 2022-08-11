//
//  accountCell.swift
//  AL-HHALIL
//
//  Created by apple on 9/7/20.
//  Copyright © 2020 Sayed Abdo. All rights reserved.
//

import UIKit

class accountCell: UITableViewCell {

    @IBOutlet weak var daenLabel: UILabel!
    @IBOutlet weak var statementLabel: UILabel!
    @IBOutlet weak var madenLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var numberLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
