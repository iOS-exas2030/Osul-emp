//
//  meetUpSecondCell.swift
//  AL-HHALIL
//
//  Created by apple on 8/30/20.
//  Copyright © 2020 Sayed Abdo. All rights reserved.
//

import UIKit
import LabelSwitch
protocol answerDel{
    func add(sender : LabelSwitch, tag : Int,id:String, answerTF : UITextField)
    func yourtext(tf :String) 
    
}
class meetUpSecondCell: UITableViewCell {

    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var cellTableView: UITableView!
    @IBOutlet weak var yourAnswerTF: UITextField!
    @IBOutlet weak var otherAnswerView: UIView!
    @IBOutlet weak var checkView: UIView!
    @IBOutlet weak var checkButton: UIButton!
    //  var selectAction2: ((_ sender : LabelSwitch, _ tag : Int)->())?
    var check: [String] = []
    var values = [""]
    var myanswers = ""
    var fullAnswerArray = [String.SubSequence]()
    var answerDelegate : answerDel?
    
    var qId : String?
    var selectAction: (()->())?
    override func awakeFromNib() {
        super.awakeFromNib()
        cellTableView.delegate = self
        cellTableView.dataSource = self
        cellTableView.registerCellNib(cellClass: MeetUpCell.self)
        checkButton.isHidden = true
        yourAnswerTF.isHidden = true
        
        self.answerDelegate?.yourtext(tf: yourAnswerTF?.text ?? "")
        let checkBoxTap = UITapGestureRecognizer(target: self, action: #selector(checkBoxAction))
        checkView.addGestureRecognizer(checkBoxTap)
        print(check)
        // Initialization code
    }
        @objc func checkBoxAction(){
            if checkButton.isHidden == true {
                checkButton.isHidden = false
                yourAnswerTF.isHidden = false
               
            }else{
                checkButton.isHidden = true
                 yourAnswerTF.isHidden = true
              
            }
        }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    @IBAction func checkBox(_ sender: UIButton) {
        //selectAction?()
        if checkButton.isHidden == true {
            checkButton.isHidden = false
            yourAnswerTF.isHidden = false
           
        }else{
            checkButton.isHidden = true
             yourAnswerTF.isHidden = true
          
        }
    }
}
extension meetUpSecondCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        fullAnswerArray = myanswers.split(separator: "|")
        return values.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeue() as MeetUpCell
        cell.answerTF.text = values[indexPath.row]
        
        if myanswers == ""{
            cell.switcherLabel.curState = .L
        }
        if fullAnswerArray.count == values.count {
         if fullAnswerArray[indexPath.row] == "yes" {
            cell.switcherLabel.curState = .R
         }
         if fullAnswerArray[indexPath.row] == "no" {
           cell.switcherLabel.curState = .L
         }
        }
        //cell.switcherLabel.tag = indexPath.row
        cell.selectAction = { sender in
            self.answerDelegate?.add(sender: sender, tag: indexPath.row,id:self.qId!, answerTF: self.yourAnswerTF)
           // self.selectAction2?(sender, indexPath.row)
        }
       // self.answerDelegate?.add(answercheck: self.check, controller: self)
        return cell
    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return CGFloat(automatic)
//    }
//    private func tableView(tableView: UITableView,heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
//    {
//        return UITableView.automaticDimension
//    }
}
