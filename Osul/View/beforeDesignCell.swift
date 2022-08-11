//
//  beforeDesignCell.swift
//  AL-HHALIL
//
//  Created by apple on 8/12/20.
//  Copyright © 2020 Sayed Abdo. All rights reserved.
//

import UIKit

protocol deleteAction{
    func Delete(index : Int)
}
class beforeDesignCell: UITableViewCell {

    @IBOutlet weak var deleteBut: UIButton!
    @IBOutlet weak var answerTF: UILabel!
    var delegate : deleteAction?
    var indexx : IndexPath = []
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func deleteButton(_ sender: UIButton) {
       //  delegate?.Delete(index: indexx.row)
    }
}
