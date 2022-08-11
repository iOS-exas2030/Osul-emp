//
//  ReviewNotificationVC.swift
//  AL-HHALIL
//
//  Created by apple on 10/10/20.
//  Copyright © 2020 Sayed Abdo. All rights reserved.
//

import UIKit
import JSSAlertView
import TransitionButton

class ReviewNotificationVC: UIViewController {

    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var masgTF: UITextView!
    @IBOutlet weak var checkView: UIView!
    @IBOutlet weak var sendReviewNotificationBtn: TransitionButton!
    
    var projectID = ""
    var clientID = ""
    var isChecked = false
    var type = ""
    override func viewDidLoad() {
        super.viewDidLoad()
            let tap2: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(check))
            checkButton.addGestureRecognizer(tap2)
        // Do any additional setup after loading the view.
        let tap3: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(check))
        checkView.addGestureRecognizer(tap3)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        getTokenReq()
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    @objc func check (){
        if(isChecked){
            checkButton.isHidden = true
            isChecked = false
        }else{
            checkButton.isHidden = false
            isChecked = true
        }
    }
    @IBAction func cancelButton(_ sender: UIButton) {
         dismiss(animated: true)
    }
    @IBAction func notifiMasgCheck(_ sender: UIButton) {
    }
    @IBAction func sendButton(_ sender: Any) {
        sendReviewNotificationBtn.startAnimation()
        if(masgTF.text == ""){
            sendReviewNotificationBtn.stopAnimation()
            JSSAlertView().danger(self, title: "عذرا", text: "برجاء ادخال نص اشعار المراجعه", buttonText: "موافق")
        }else{
            send_revision()
        }
    }
    func send_revision(){
        if(isChecked){
            type = "1"
        }else{
            type = "0"
        }
        let userId = UserDefaults.standard.value(forKey: "userId") as? String
        NetworkClient.performRequest(statusModel.self, router: .send_revision(project_id: projectID, emp_id: userId!, client_id: clientID, msg: masgTF.text,type:type), success: { [weak self] (models) in
           // self!.NotificationReviewView.isHidden = true
            if(models.status == 1){
                let alertview = JSSAlertView().success(self!,title: "حسنا",text: "تم إرسال الإشعار بنجاح", buttonText: "موافق")
                alertview.addAction {
                   self!.dismiss(animated: true)
                }

            }
            else if (models.status == 0 ){
                let alertview = JSSAlertView().danger(self!, title: "عذرا", text: "حدث حطأ ما حاول مره اخري", buttonText: "موافق")
                alertview.addAction {
                    self!.dismiss(animated: true)
                }
            }
        }){ [weak self] (error) in
            self?.sendReviewNotificationBtn.stopAnimation()
            JSSAlertView().danger(self!, title: "عذرا", text: "تأكد من اتصالك بالانترنت", buttonText: "موافق")
        }
    }
}
