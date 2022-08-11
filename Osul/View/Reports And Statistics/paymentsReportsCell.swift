//
//  paymentsReportsCell.swift
//  AL-HHALIL
//
//  Created by Sayed Abdo on 8/27/20.
//  Copyright © 2020 Sayed Abdo. All rights reserved.
//

import UIKit

class paymentsReportsCell: UITableViewCell {
    
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var projectName: UILabel!
    @IBOutlet weak var totlaPatmentLabel: UILabel!
    @IBOutlet weak var totalNotType: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
