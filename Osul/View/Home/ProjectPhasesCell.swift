//
//  ProjectPhasesCell.swift
//  AL-HHALIL
//
//  Created by apple on 7/7/20.
//  Copyright © 2020 Sayed Abdo. All rights reserved.
//

import UIKit
import MBCircularProgressBar

class ProjectPhasesCell: UICollectionViewCell {

    @IBOutlet weak var projectBorderView: UIView!
    @IBOutlet weak var notification: UIButton!
    @IBOutlet weak var phaseName: UILabel!
    @IBOutlet weak var phasesProgress: MBCircularProgressBarView!
    
    @IBOutlet weak var stamp: UIImageView!
    @IBOutlet weak var chatNotification: UIImageView!
    var createdBy : String?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }
    override func prepareForReuse() {
        super.prepareForReuse()
//        if(createdBy == "1"){
//          //  let color1 = #colorLiteral(red: 0.7734938264, green: 0.0884700045, blue: 0, alpha: 1)
//            projectBorderView.borderWidth = 0
//            projectBorderView.backgroundColor = #colorLiteral(red: 0.697083652, green: 0.2605850995, blue: 0.2016019523, alpha: 0.4848833476)
//            phasesProgress.backgroundColor = #colorLiteral(red: 0.697083652, green: 0.2605850995, blue: 0.2016019523, alpha: 0)
//          //  cell.backgroundColor = #colorLiteral(red: 0.697083652, green: 0.2605850995, blue: 0.2016019523, alpha: 0.4848833476)
//        }else{
//            projectBorderView.borderWidth = 0
//            backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//        }
    }
    
    func phasesStatus(){
        if(createdBy == "1"){
          //  let color1 = #colorLiteral(red: 0.7734938264, green: 0.0884700045, blue: 0, alpha: 1)
            projectBorderView.borderWidth = 0
            projectBorderView.backgroundColor = #colorLiteral(red: 0.4763007164, green: 0.2721414864, blue: 0.625670135, alpha: 0.8470588235)
            phasesProgress.backgroundColor = #colorLiteral(red: 0.697083652, green: 0.2605850995, blue: 0.2016019523, alpha: 0)
          //  cell.backgroundColor = #colorLiteral(red: 0.697083652, green: 0.2605850995, blue: 0.2016019523, alpha: 0.4848833476)
        }else{
            projectBorderView.borderWidth = 0
            backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
    }
}
