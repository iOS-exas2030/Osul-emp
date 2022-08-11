//
//  ChangePasswordVC.swift
//  AL-HHALIL
//
//  Created by apple on 7/12/20.
//  Copyright © 2020 Sayed Abdo. All rights reserved.
//

import UIKit
import JSSAlertView
import TransitionButton
class ChangePasswordVC: UIViewController ,UITextFieldDelegate {

    //MARK: - IBOutlets
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var newPasswordTF: UITextField!
    @IBOutlet weak var changeBtn: TransitionButton!
    //MARK: - Properties
    var changePassword : ChangePasswordModel?
    var phone : String = ""
    var check = false
    //MARK: - View Controller Builder
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
           tap.cancelsTouchesInView = false
           view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
        phoneTF.delegate = self
        newPasswordTF.delegate = self
    }
    @objc func dismissKeyboard() {
             view.endEditing(true)
    }
    @IBAction func changeButton(_ sender: UIButton) {
        changeBtn.startAnimation()
        if(phoneTF.text == ""){
             self.changeBtn.stopAnimation()
            JSSAlertView().danger(self, title: "خطأ", text: "برجاء إدخال كلمه المرور الجديده", buttonText: "موافق")
        }else if(newPasswordTF.text == ""){
             self.changeBtn.stopAnimation()
            JSSAlertView().danger(self, title: "خطأ", text: "برجاء إدخال تأكيد كلمه المرور الجديده", buttonText: "موافق")
        }else if(phoneTF.text!.count < 6){
             self.changeBtn.stopAnimation()
            JSSAlertView().danger(self, title: "عذرا", text: "يجب ان يكون كلمة السر ٦ ارقام او اكثر", buttonText: "موافق")
        }else if(newPasswordTF.text! != phoneTF.text!){
             self.changeBtn.stopAnimation()
            JSSAlertView().danger(self, title: "عذرا", text: "كلمه المرور غير متصابقه", buttonText: "موافق")
        }else{
            changePassword(phone: phone, password: newPasswordTF.text ?? "")
        }
    }
    
    @IBAction func changePasswordView(_ sender: UIButton) {
        if check {
            phoneTF.isSecureTextEntry = true
            sender.setImage(UIImage(named: "HidePassword"), for: .normal)
            check = false
        }
        else {
            phoneTF.isSecureTextEntry = false
            sender.setImage(UIImage(named: "ShowPassword"), for: .normal)
            check = true
        }
    }
    @IBAction func confirmPasswordView(_ sender: UIButton) {
        if check {
            newPasswordTF.isSecureTextEntry = true
            sender.setImage(UIImage(named: "HidePassword"), for: .normal)
            check = false
        }
        else {
            newPasswordTF.isSecureTextEntry = false
            sender.setImage(UIImage(named: "ShowPassword"), for: .normal)
            check = true
        }
    }
    
}
//MARK: - UITextFieldDelegate
extension ChangePasswordVC{
    //
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if(textField == phoneTF){
            phoneTF.layer.borderColor = #colorLiteral(red: 0.3960784314, green: 0.1843137255, blue: 0.5568627451, alpha: 1) //your color
            phoneTF.layer.borderWidth = 1.0
        }else if(textField == newPasswordTF){
            newPasswordTF.layer.borderColor = #colorLiteral(red: 0.3960784314, green: 0.1843137255, blue: 0.5568627451, alpha: 1) //your color
            newPasswordTF.layer.borderWidth = 1.0
        }
    }
    //
    func textFieldDidEndEditing(_ textField: UITextField) {
        if(textField == phoneTF){
            phoneTF.layer.borderWidth = 0.0
        }else if(textField == newPasswordTF){
            newPasswordTF.layer.borderWidth = 0.0
        }
    }
    //
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(textField == phoneTF){
            textField.resignFirstResponder()
            newPasswordTF.becomeFirstResponder()
        }else if(textField == newPasswordTF){
            self.view.endEditing(true)
        }
        return true
    }
}
//MARK: - Request
extension ChangePasswordVC{
    func changePassword(phone : String , password : String){
        NetworkClient.performRequest(ChangePasswordModel.self, router: .changepassword(phone: phone, password: password), success: { [weak self] (models) in
            self?.changePassword = models
            if(models.status == 1){
                self?.changeBtn.stopAnimation()
                JSSAlertView().success(self!,title: "حسنا",text: "تم تغيير كلمه المرور بنجاح", buttonText: "موافق")
                let view = self?.storyboard?.instantiateViewController(withIdentifier: "LogInVC") as! LogInVC
                self?.navigationController?.pushViewController(view, animated: true)
            }
            else if (models.status == 0 ){
                self?.changeBtn.stopAnimation()
                JSSAlertView().danger(self!, title: "عذرا", text: models.arMsg, buttonText: "موافق")
            }
        }){ [weak self] (error) in
            self?.changeBtn.stopAnimation()
                JSSAlertView().danger(self!, title: "عذرا", text: "تأكد من اتصالك بالانترنت", buttonText: "موافق")
            }
    }
}
