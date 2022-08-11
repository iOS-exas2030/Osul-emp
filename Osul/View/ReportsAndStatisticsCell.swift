//
//  ReportsAndStatisticsCell.swift
//  AL-HHALIL
//
//  Created by Sayed Abdo && Aya Bahaa on 7/3/20.
//  Copyright © 2020 Sayed Abdo && Aya Bahaa. All rights reserved.
//

import UIKit

class ReportsAndStatisticsCell: UITableViewCell {

    @IBOutlet weak var reportsAndStatisticsImage: UIImageView!
    @IBOutlet weak var reportsAndStatisticsName: UILabel!
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
