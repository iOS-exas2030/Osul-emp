//
//  receiptCell.swift
//  AL-HHALIL
//
//  Created by apple on 8/23/20.
//  Copyright © 2020 Sayed Abdo. All rights reserved.
//

import UIKit

class receiptCell: UITableViewCell {

    
    @IBOutlet weak var indexNumberLabel: UILabel!
    @IBOutlet weak var projecctNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var priceLacel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
