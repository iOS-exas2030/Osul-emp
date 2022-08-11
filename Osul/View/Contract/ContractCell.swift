//
//  ContractCell.swift
//  AL-HHALIL
//
//  Created by Sayed Abdo on 7/3/20.
//  Copyright © 2020 Sayed Abdo. All rights reserved.
//

import UIKit
import MBCircularProgressBar

class ContractCell: UITableViewCell {

    @IBOutlet weak var orderDate: UILabel!
    @IBOutlet weak var clientName: UILabel!
    @IBOutlet weak var contractType: UILabel!
    @IBOutlet weak var projectProgress: MBCircularProgressBarView!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var dataView: UIView!
    @IBOutlet weak var projectNameView: UIView!
    @IBOutlet weak var contractTypeView: UIView!
  //  @IBOutlet weak var projectType: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
