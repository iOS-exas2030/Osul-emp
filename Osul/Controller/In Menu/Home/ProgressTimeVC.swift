//
//  ProgressTimeVC.swift
//  AL-HHALIL
//
//  Created by Sayed Abdo on 10/24/20.
//  Copyright © 2020 Sayed Abdo. All rights reserved.
//

import UIKit
import JSSAlertView
import TransitionButton

protocol ProjectTimeDelegate {
     func reload()
}
class ProgressTimeVC: UIViewController {
    
    @IBOutlet weak var daysDropDown: DropDown!
    @IBOutlet weak var progressBtn: TransitionButton!
    @IBOutlet weak var editBtn: UIButton!
    
    var days = [String]()
    var ProgressTime = ""
    var levelID = ""
    var delegate: ProjectTimeDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        progressBtn.isEnabled = false
        daysDropDown.text = ProgressTime
        for dayscounter in 0..<365 {
            days.append("\(dayscounter)")
        }
        self.daysDropDown.text = self.ProgressTime
        daysDropDown.optionArray = self.days
        daysDropDown.rowHeight = 50
        self.daysDropDown.didSelect{(selectedText , index ,id) in
            //self.view.makeToast("تم تحديد مده المشروع", duration: 3.0, position: .bottom)
            self.ProgressTime = self.days[index]
            self.progressBtn.isEnabled = true
        }
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        let isProgressTime = UserDefaults.standard.value(forKeyPath: "isProgressTime") as? String
        if(isProgressTime == "0"){
            editBtn.isHidden = true
        }else{
            editBtn.isHidden = false
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        self.getTokenReq()
    }
    @objc func dismissKeyboard() {
             view.endEditing(true)
    }
    @IBAction func dismissViewAction(_ sender: Any) {
        dismiss(animated: true)
    }
    @IBAction func editTime(_ sender: Any) {
        daysDropDown.isEnabled = true
        daysDropDown.borderColor = #colorLiteral(red: 0.3960784314, green: 0.1843137255, blue: 0.5568627451, alpha: 1)
        daysDropDown.borderWidth = 0.5
        daysDropDown.cornerRadius = 5
    }
    @IBAction func saveTime(_ sender: Any) {
        let alertview = JSSAlertView().info(self,title: "تنبيه !",text: "هل تريد حفظ مده المرحله ؟",
                        buttonText: "موافق",cancelButtonText: "لاحقا" )
        alertview.addAction {
            self.progressTime()
        }
        alertview.addCancelAction {
            print("cancel")
        }
    }
}
//MARK: - Request
extension ProgressTimeVC{
        func progressTime(){
            NetworkClient.performRequest(progressTimeModel.self, router: .projectUpdateProgressTime(level_id: levelID, progress_time: ProgressTime), success: { [weak self] (models) in
               //  self?.assign = models
                print("models\( models.data)")
                 if(models.status == 1){
                    if let delegate = self?.delegate {
                        delegate.reload()
                     }
                    let alertview = JSSAlertView().success(self!,title : "حسنا",text: "تم الحفظ بنجاح", buttonText: "موافق")
                    alertview.addAction {
                       self!.dismiss(animated: true)
                    }
                 }
                 else if (models.status == 0 ){
                 }
             }){ [weak self] (error) in
             }
         }
}
