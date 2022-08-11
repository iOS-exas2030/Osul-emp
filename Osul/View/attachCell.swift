//
//  attachCell.swift
//  AL-HHALIL
//
//  Created by apple on 8/23/20.
//  Copyright © 2020 Sayed Abdo. All rights reserved.
//

import UIKit

class attachCell: UICollectionViewCell {

    @IBOutlet weak var attachment: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
      //  attachment.isEnabled = false
        attachment.isUserInteractionEnabled = false
    }

}
