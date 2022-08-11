//
//  uploadImageCellCollectionViewCell.swift
//  AL-HHALIL
//
//  Created by apple on 11/4/20.
//  Copyright © 2020 Sayed Abdo. All rights reserved.
//

import UIKit

class uploadImageCellCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageQues: UIImageView!
    // var selectActionImage: ((_ sender : UIImageView)->())?
    override func awakeFromNib() {
        super.awakeFromNib()
    imageQues.isUserInteractionEnabled = false
      //  selectActionImage?(imageQues)
         
        // Initialization code
    }

}
