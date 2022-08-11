//
//  MeetUpCell.swift
//  AL-HHALIL
//
//  Created by apple on 7/16/20.
//  Copyright © 2020 Sayed Abdo. All rights reserved.
//

import UIKit
import LabelSwitch
class MeetUpCell: UITableViewCell {

    
    @IBOutlet weak var answerTF: UILabel!
    @IBOutlet weak var switcherLabel: LabelSwitch!
    
    var selectAction: ((_ sender : LabelSwitch)->())?
    override func awakeFromNib() {
        super.awakeFromNib()
        switcherLabel.delegate = self
        //switcherLabel.curState = .L
        switcherLabel.circleShadow = false
        switcherLabel.fullSizeTapEnabled = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

//    override func prepareForReuse() {
//        <#code#>
//    }
    
}
extension MeetUpCell: LabelSwitchDelegate  {
    func switchChangToState(sender: LabelSwitch) {
        selectAction?(sender)
//        switch sender.curState {
//        case .L: print("left")
//        case .R: print("right")
//        }
    }
}
