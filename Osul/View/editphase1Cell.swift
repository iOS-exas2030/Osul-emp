//
//  editphase1Cell.swift
//  AL-HHALIL
//
//  Created by apple on 7/21/20.
//  Copyright © 2020 Sayed Abdo. All rights reserved.
//

import UIKit

class editphase1Cell: UITableViewCell {

    @IBOutlet weak var percentagePhase: UILabel!
    @IBOutlet weak var phaseName: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
     var selectAction: (()->())?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func editButton(_ sender: UIButton) {
        selectAction?()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
