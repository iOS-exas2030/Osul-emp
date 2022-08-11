//
//  ControlPanelCell.swift
//  AL-HHALIL
//
//  Created by Sayed Abdo on 7/3/20.
//  Copyright © 2020 Sayed Abdo. All rights reserved.
//

import UIKit

class ControlPanelCell: UITableViewCell {

    
    @IBOutlet weak var ControlPanelImage: UIImageView!
    @IBOutlet weak var ControlPanelName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // change background Color of cell when select or dis select
        if selected {
            contentView.backgroundColor = #colorLiteral(red: 0.3960784314, green: 0.1843137255, blue: 0.5568627451, alpha: 1)
        } else {
            contentView.backgroundColor = UIColor.white
        }
    }
}
