//
//  meetUpFirstCell.swift
//  AL-HHALIL
//
//  Created by apple on 8/30/20.
//  Copyright © 2020 Sayed Abdo. All rights reserved.
//

import UIKit
protocol textFieldDelegete {
    func delegate(TF :String)
}

class meetUpFirstCell: UITableViewCell ,UITextFieldDelegate,UITextViewDelegate{

    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerTF: UITextView!
    
    var arrayOfNames = ""
    var rowBeingEdited : Int? = nil
     var TFDelegate : textFieldDelegete?
    var answers = ""
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.TFDelegate?.delegate(TF: answerTF?.text ?? "")
        answerTF.delegate = self
      //  answerTF.delegate = self as! UITextViewDelegate
        
    }
    public func configure(text: String? ) {
        answerTF.text = text

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func returnTextOfTextField() -> String
    {
        print(answerTF.text)
       return answerTF.text!
    }
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        print("qqqqqq")
//        answers.append(contentsOf: "\(answerTF.text),")
//    }
    
    

}
