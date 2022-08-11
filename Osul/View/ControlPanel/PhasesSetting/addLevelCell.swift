//
//  addLevelCell.swift
//  AL-HHALIL
//
//  Created by apple on 8/11/20.
//  Copyright © 2020 Sayed Abdo. All rights reserved.
//

import UIKit
protocol action{
    func Delete(index : Int)
}
class addLevelCell: UITableViewCell {

    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var delete: UIButton!
    @IBOutlet weak var precLabel: UILabel!
    @IBOutlet weak var attachmentImage: UIImageView!
    @IBOutlet weak var displayStatus: UIButton!
    var delegate : action?
    var indexx : IndexPath = []
    var selectedDisplayAction: (()->())?
    var selectAction: (()->())?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func deleteButton(_ sender: UIButton) {
       // selectAction?()
//        delegate?.Delete(index: indexx.row)
    }
    
    @IBAction func displauStatusAction(_ sender: Any) {
        selectedDisplayAction!()
    }
}
