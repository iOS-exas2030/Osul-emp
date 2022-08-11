//
//  ExplanationsCell.swift
//  AL-HHALIL
//
//  Created by Sayed Abdo on 8/13/20.
//  Copyright © 2020 Sayed Abdo. All rights reserved.
//

import UIKit

class ExplanationsCell: UITableViewCell {
    
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var ExplanationsNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
