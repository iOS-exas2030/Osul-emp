//
//  ForgetPasswordVC.swift
//  AL-HHALIL
//
//  Created by apple on 7/12/20.
//  Copyright © 2020 Sayed Abdo. All rights reserved.
//

import UIKit
import FasterVerificationCode
import JSSAlertView
import TransitionButton
class ForgetPasswordVC: UIViewController ,UITextFieldDelegate {
    
    //MARK: - IBOutlets
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var sendBtn: TransitionButton!
    //MARK: - Properties
    var changePassword : ChangePasswordModel?
    var login : LoginModel?

    //MARK: - View Controller Builder
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        phoneTF.delegate = self
        self.navigationController?.isNavigationBarHidden = true
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
           tap.cancelsTouchesInView = false
           view.addGestureRecognizer(tap)
    }
    override func viewWillAppear(_ animated: Bool) {
    }
    @objc func dismissKeyboard() {
          view.endEditing(true)
    }
    @IBAction func forgetPasswordButton(_ sender: UIButton) {
        sendBtn.startAnimation()
        if(phoneTF.text == ""){
            self.sendBtn.stopAnimation()
            JSSAlertView().danger(self, title: "خطأ", text: "برجاء ادخال رقم الجوال او البريد الالكتروني المستخدم أولا ", buttonText: "موافق")
        }else{
            forgetPass(phone: phoneTF.text ?? "")
        }
      }
    @IBAction func backButton(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}
//MARK: - UITextFieldDelegate
extension ForgetPasswordVC{
    //
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if(textField == phoneTF){
            phoneTF.layer.borderColor = #colorLiteral(red: 0.3960784314, green: 0.1843137255, blue: 0.5568627451, alpha: 1) //your color
            phoneTF.layer.borderWidth = 1.0
        }
    }
    //
    func textFieldDidEndEditing(_ textField: UITextField) {
        if(textField == phoneTF){
            phoneTF.layer.borderWidth = 0.0
        }
    }
    //
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
//MARK: - Request
extension ForgetPasswordVC{
    func forgetPass(phone : String ){
        NetworkClient.performRequest(ChangePasswordModel.self, router: .forgetPassword(phone: phone), success: { [weak self] (models) in
            self?.changePassword = models
                print("models\( models)")
            if(models.status == 1){
                self?.sendBtn.stopAnimation()
                let view = self?.storyboard?.instantiateViewController(withIdentifier: "verificationCodeVC") as! verificationCodeVC
                view.phone = self?.phoneTF.text! ?? ""
                self?.navigationController?.pushViewController(view, animated: true)
            }
            else if (models.status == 0 ){
                print("errorrr")
                self?.sendBtn.stopAnimation()
                JSSAlertView().danger(self!, title: "عذرا", text: models.arMsg, buttonText: "موافق")

            }
        }){ [weak self] (error) in
            self?.sendBtn.stopAnimation()
           
            }
    }
}
