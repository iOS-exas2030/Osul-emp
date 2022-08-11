//
//  PdfMailBoxCell.swift
//  AL-HHALIL
//
//  Created by Sayed Abdo on 8/27/20.
//  Copyright © 2020 Sayed Abdo. All rights reserved.
//

import UIKit

class PdfMailBoxCell: UICollectionViewCell {
    
    @IBOutlet weak var openFileBtn: UIButton!
    override func awakeFromNib() {
           super.awakeFromNib()
           // Initialization code
        openFileBtn.isUserInteractionEnabled = false
       }
    
}
