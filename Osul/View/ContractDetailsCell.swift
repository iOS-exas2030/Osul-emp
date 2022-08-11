//
//  ContractDetailsCell.swift
//  AL-HHALIL
//
//  Created by Sayed Abdo on 7/23/20.
//  Copyright © 2020 Sayed Abdo. All rights reserved.
//

import UIKit

class ContractDetailsCell: UITableViewCell {
    
    
    @IBOutlet weak var fixedTitle: UILabel!
    @IBOutlet weak var displayEye: UIButton!
    @IBOutlet weak var sentBtn: UIButton!
    @IBOutlet weak var DeleteBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
