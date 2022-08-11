//
//  sendNotificationVC.swift
//  AL-HHALIL
//
//  Created by apple on 10/10/20.
//  Copyright © 2020 Sayed Abdo. All rights reserved.
//

import UIKit
import JSSAlertView
import DLRadioButton
import TransitionButton

class sendNotificationVC: UIViewController {

    @IBOutlet weak var smsNotifi: DLRadioButton!
    @IBOutlet weak var emailNotifi: DLRadioButton!
    @IBOutlet weak var bothNotifi: DLRadioButton!
    
    @IBOutlet weak var sendNotifBtn: TransitionButton!
    
     var shareNumber: Int = 0
     var shareType : Int = 0
     var projectID = ""
     var clientID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(shareNumber)
        // Do any additional setup after loading the view.
        
    }
    override func viewWillAppear(_ animated: Bool) {
        getTokenReq()
    }
    
    @IBAction func cancelButton(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func smsNotifiButton(_ sender: DLRadioButton) {
        smsNotifi.isSelected = true
        shareType = 1
    }
    
    @IBAction func emailNotifiButton(_ sender: DLRadioButton) {
        emailNotifi.isSelected = true
        shareType = 2
    }
    
    @IBAction func bothNotifiButton(_ sender: DLRadioButton) {
        bothNotifi.isSelected = true
        shareType = 3
    }
    @IBAction func sendButton(_ sender: UIButton) {
        sendNotifBtn.startAnimation()
        print("wwwwww : \(shareType)")
        if(shareNumber == 1){
            if(shareType == 0){
                sendNotifBtn.stopAnimation()
                JSSAlertView().danger(self, title: "عذرا", text: "برجاء تحديد نوع الاشعار", buttonText: "موافق")
            }else{
                print("sssssssssssssssssssssss")
                shareProjectSurveyReq()
            }
        }else if(shareNumber == 2){
            if(shareType == 0){
                sendNotifBtn.stopAnimation()
                JSSAlertView().danger(self, title: "عذرا", text: "برجاء تحديد نوع الاشعار", buttonText: "موافق")
            }else{
                sharesend_priceReq()
            }
        }else if(shareNumber == 3){
            if(shareType == 0){
                sendNotifBtn.stopAnimation()
                JSSAlertView().danger(self, title: "عذرا", text: "برجاء تحديد نوع الاشعار", buttonText: "موافق")
            }else{
                shareSend_contractReq()
            }
        }else if(shareNumber == 4){
            if(shareType == 0){
                sendNotifBtn.stopAnimation()
                JSSAlertView().danger(self, title: "عذرا", text: "برجاء تحديد نوع الاشعار", buttonText: "موافق")
            }else{
                shareTransferMoneyReq()
            }
        }

    }
    
}
extension sendNotificationVC {
    
    func shareProjectSurveyReq(){
        let userId = UserDefaults.standard.value(forKey: "userId") as? String
        NetworkClient.performRequest(statusModel.self, router: .shareMainProjectSurvey(project_id: projectID, client_id: clientID, contract_id: "\(shareType)", emp_id: userId!),success: { [weak self] (models) in
           // self!.selectNotificationView.isHidden = true
            if(models.status == 1){
                self?.sendNotifBtn.stopAnimation()
                let alertview = JSSAlertView().success(self!,title: "حسنا",text: "تم إرسال الإشعار بنجاح", buttonText: "موافق")
                alertview.addAction {
                   self!.dismiss(animated: true)
                }
            }
            else if (models.status == 0 ){
                self?.sendNotifBtn.stopAnimation()
                let alertview = JSSAlertView().danger(self!, title: "عذرا", text: "حدث حطأ ما حاول مره اخري", buttonText: "موافق")
                alertview.addAction {
                    self!.dismiss(animated: true)
                }
            }
        }){ [weak self] (error) in
            self?.sendNotifBtn.stopAnimation()
            JSSAlertView().danger(self!, title: "عذرا", text: "تأكد من اتصالك بالانترنت", buttonText: "موافق")
        }
    }
    func shareTransferMoneyReq(){
        let userId = UserDefaults.standard.value(forKey: "userId") as? String
        NetworkClient.performRequest(statusModel.self, router: .send_paid_project(project_id: projectID, emp_id: userId!, contract_id: "\(shareType)", client_id: clientID),success: { [weak self] (models) in
            print("models\( models)")
          //  self!.selectNotificationView.isHidden = true
            if(models.status == 1){
                self?.sendNotifBtn.stopAnimation()
                let alertview = JSSAlertView().success(self!,title: "حسنا",text: "تم إرسال الإشعار بنجاح", buttonText: "موافق")
                alertview.addAction {
                   self!.dismiss(animated: true)
                }
            }
            else if (models.status == 0 ){
                self?.sendNotifBtn.stopAnimation()
                let alertview = JSSAlertView().danger(self!, title: "عذرا", text: models.arMsg, buttonText: "موافق")
                alertview.addAction {
                    self!.dismiss(animated: true)
                }
            }
        }){ [weak self] (error) in
                self?.sendNotifBtn.stopAnimation()
                JSSAlertView().danger(self!, title: "عذرا", text: "تأكد من اتصالك بالانترنت", buttonText: "موافق")
        }
    }
    func shareSend_contractReq(){
        let userId = UserDefaults.standard.value(forKey: "userId") as? String
        NetworkClient.performRequest(statusModel.self, router: .send_contract(emp_id: userId!, project_id: projectID, client_id: clientID, type: "\(shareType)"),success: { [weak self] (models) in
             print("models\( models)")
            // self!.selectNotificationView.isHidden = true
             if(models.status == 1){
                self?.sendNotifBtn.stopAnimation()
                 let alertview = JSSAlertView().success(self!,title: "حسنا",text: "تم إرسال الإشعار بنجاح", buttonText: "موافق")
                 alertview.addAction {
                    self?.dismiss(animated: true)
                 }
             }
             else if (models.status == 0 ){
                self?.sendNotifBtn.stopAnimation()
                 let alertview = JSSAlertView().danger(self!, title: "عذرا", text: "حدث حطأ ما حاول مره اخري", buttonText: "موافق")
                 alertview.addAction {
                     self!.dismiss(animated: true)
                 }
             }
         }){ [weak self] (error) in
                 self?.sendNotifBtn.stopAnimation()
                 JSSAlertView().danger(self!, title: "عذرا", text: "تأكد من اتصالك بالانترنت", buttonText: "موافق")
         }
     }
    func sharesend_priceReq(){
        let userId = UserDefaults.standard.value(forKey: "userId") as? String
        NetworkClient.performRequest(statusModel.self, router: .send_price(emp_id: userId!, project_id: projectID, client_id: clientID, type: "\(shareType)"),success: { [weak self] (models) in
            print("models\( models)")
           // self!.selectNotificationView.isHidden = true
            if(models.status == 1){
                self?.sendNotifBtn.stopAnimation()
                let alertview = JSSAlertView().success(self!,title: "حسنا",text: "تم إرسال الإشعار بنجاح", buttonText: "موافق")
                alertview.addAction {
                   self!.dismiss(animated: true)
                }
            }
            else if (models.status == 0 ){
                self?.sendNotifBtn.stopAnimation()
                let alertview = JSSAlertView().danger(self!, title: "عذرا", text: "حدث حطأ ما حاول مره اخري", buttonText: "موافق")
                alertview.addAction {
                    self!.dismiss(animated: true)
                }
            }
        }){ [weak self] (error) in
                self?.sendNotifBtn.stopAnimation()
                JSSAlertView().danger(self!, title: "عذرا", text: "تأكد من اتصالك بالانترنت", buttonText: "موافق")
        }
    }


}
