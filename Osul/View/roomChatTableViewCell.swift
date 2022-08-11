//
//  roomChatTableViewCell.swift
//  Hermosa
//
//  Created by apple on 12/10/19.
//  Copyright © 2019 Softagi. All rights reserved.
//

import UIKit

class roomChatTableViewCell: UITableViewCell {
    
    
    enum bubbleType{
        case incoming
        case outcoming
        
    } 
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var timeTF: UILabel!
    @IBOutlet weak var chatView: UIView!
    @IBOutlet weak var chatStackView: UIStackView!
    @IBOutlet weak var messageTextfield: UITextView!
    @IBOutlet weak var userNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setBubbleDataForMessage(message: ChatModelDatum){
        if(message.message != nil) {
            self.messageTextfield.text = message.message
        } else if(message.file != nil){
            self.imgView.image = UIImage(named: "paper")
        }
        
      //  self.senderNameLabel.text = message.senderUsername
    }
    func setBubbleType(type: bubbleType){
        if ( type == .incoming){
            chatStackView.alignment = .leading
            chatView.backgroundColor = .white
            messageTextfield.textColor = .black
           
        }else if (type == .outcoming){
            chatStackView.alignment = .trailing
            chatView.backgroundColor = #colorLiteral(red: 0.3960784314, green: 0.1843137255, blue: 0.5568627451, alpha: 1)
            messageTextfield.textColor = .white
        }
    }
    
}
