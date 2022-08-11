//
//  verificationCodeVC.swift
//  AL-HHALIL
//
//  Created by apple on 7/13/20.
//  Copyright © 2020 Sayed Abdo. All rights reserved.
//

import UIKit
import FasterVerificationCode
import JSSAlertView
class verificationCodeVC: UIViewController {

    @IBOutlet weak var codeView: VerificationCodeView!
    var phone : String = ""
    var login : LoginModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        print("phone \(phone)")
        codeView.setLabelNumber(4)
        codeView.delegate = self
        // Do any additional setup after loading the view.
        
    }
    override func didReceiveMemoryWarning() {
         super.didReceiveMemoryWarning()
         // Dispose of any resources that can be recreated.
     }
  
    func checkCode(phone : String , code : String){
        
         NetworkClient.performRequest(LoginModel.self, router: .checkCode(phone: phone, code: code), success: { [weak self] (models) in
                 self?.login = models
             if(models.status == 1){
                let view = self?.storyboard?.instantiateViewController(withIdentifier: "ChangePasswordVC") as! ChangePasswordVC
                view.phone = phone
                self?.navigationController?.pushViewController(view, animated: true)
             }
             else if (models.status == 0 ){
                 print("errorrr")
                JSSAlertView().danger(self!, title: "خطأ", text: "كلمة التحقق غير صحيحة", buttonText: "موافق")
                self?.navigationController?.popViewController(animated: true)
                self?.codeView.showError = true
             }
         }){ [weak self] (error) in
                JSSAlertView().danger(self!, title: "عذرا", text: "تأكد من اتصالك بالانترنت", buttonText: "موافق")
           }
     }
}
extension verificationCodeVC: VerificationCodeViewDelegate
{
    func verificationCodeInserted(_ text: String, isComplete: Bool)
    {
         checkCode(phone: phone, code: text)
    }
    func verificationCodeChanged()
    {
        codeView.showError = false
    }
}

