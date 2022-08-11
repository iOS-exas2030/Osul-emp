//
//  imageChatCell.swift
//  AL-HHALIL
//
//  Created by apple on 12/21/20.
//  Copyright © 2020 Sayed Abdo. All rights reserved.
//

import UIKit

class imageChatCell: UITableViewCell {
    
    enum bubbleType{
        case incoming
        case outcoming
        
    }

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var chatStack: UIStackView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setBubbleType(type: bubbleType){
        if ( type == .incoming){
            chatStack.alignment = .leading
          //  chatView.backgroundColor = .white
          //  messageTextfield.textColor = .black
           
        }else if (type == .outcoming){
            chatStack.alignment = .trailing
           // chatView.backgroundColor = #colorLiteral(red: 0.7607843137, green: 0, blue: 0.0431372549, alpha: 1)
          //  messageTextfield.textColor = .white
        }
    }
    
}
