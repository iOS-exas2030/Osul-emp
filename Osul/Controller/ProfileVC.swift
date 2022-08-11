//
//  ProfileVC.swift
//  AL-HHALIL
//
//  Created by apple on 10/11/20.
//  Copyright © 2020 Sayed Abdo. All rights reserved.
//

import UIKit
import JSSAlertView
import Firebase
import FirebaseAuth

class ProfileVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var oldPasswordTF: UITextField!
    
    @IBOutlet weak var newPasswordTF: UITextField!
    var data : ProfileModel?
    var Cons :Constants?
    override func viewDidLoad() {
        super.viewDidLoad()
        let userName = UserDefaults.standard.value(forKey: "userName") as? String
        nameTF.text = "\(userName!)"
        let userPhone = UserDefaults.standard.value(forKeyPath: "userPhone") as? String
        let str = userPhone!
        let index = str.index((str.endIndex), offsetBy: -9)
        let mySubstring = str.suffix(from: index)
        print(mySubstring)
        phoneTF.text = String(mySubstring)
        let userEmail = UserDefaults.standard.value(forKeyPath: "userEmail") as? String
        emailTF.text = userEmail!
        let userAddress = UserDefaults.standard.value(forKeyPath: "userAddress") as? String
        address.text = userAddress
        phoneTF.delegate = self
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
        self.getTokenReq()
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    @IBAction func saveButton(_ sender: Any) {
        if(oldPasswordTF.text == ""){
        JSSAlertView().danger(self, title: "خطأ", text: "برجاء ادخال كلمه المرور الأول ", buttonText: "موافق")
        }else if(phoneTF.text?.count != 9){
            JSSAlertView().danger(self, title: "عذرا", text: "ادخل رقم الهاتف مكون من ٩ رقم", buttonText: "موافق")
        }else if(newPasswordTF.text!.count < 6){
            JSSAlertView().danger(self, title: "عذرا", text: "يجب ان يكون كلمة السر ٦ ارقام او اكثر", buttonText: "موافق")
        }else{
            let alertview = JSSAlertView().warning(self,title: "تنبيه !",text: "هل تريد حفظ التعديلات ؟",buttonText: "موافق",cancelButtonText: "إلغاء" )
                alertview.addAction {
                self.post_profile()

            }
            alertview.addCancelAction {
                print("cancel")
            }
        }
    }
    func changePassword(email: String, currentPassword: String, newPassword: String) {
      let credential = EmailAuthProvider.credential(withEmail: email, password: currentPassword)
      Auth.auth().currentUser?.reauthenticate(with: credential, completion: { (result, error) in
        if error == nil {
            Auth.auth().currentUser?.updatePassword(to: newPassword) { (errror) in
                print(error)
        }
        } else {
            print(error)
        }
     })
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = "1234567890"
        let allowedCharacterSet = CharacterSet(charactersIn: allowedCharacters)
        let typedCharacterSet = CharacterSet(charactersIn: string)
        let alphabet = allowedCharacterSet.isSuperset(of: typedCharacterSet)
        let maxLength = 9
        let currentString: NSString = (textField.text ?? "") as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength && alphabet
    }
   func post_profile(){
    let userId = UserDefaults.standard.value(forKey: "userId") as? String
    let phone = "966" + (phoneTF.text ?? "")
    NetworkClient.performRequest(ProfileModel.self, router: .profile(id: userId!, email: emailTF.text ?? "", phone: phone, name: nameTF.text ?? "" , address: address.text ?? "", oldPassword: oldPasswordTF.text! , passsword: newPasswordTF.text ?? ""), success: { [weak self] (models) in
        self?.data = models
        if(models.status == 1){
               // self?.changePassword(email: self?.emailTF.text ?? "", currentPassword: self?.oldPasswordTF.text ?? "", newPassword: self?.newPasswordTF.text ?? "")
                UserDefaults.standard.removeObject(forKey: "userId")
                UserDefaults.standard.removeObject(forKey: "rememberMe")
                UserDefaults.standard.removeObject(forKey: "userName")
                UserDefaults.standard.removeObject(forKey: "userPhone")
                UserDefaults.standard.removeObject(forKey: "userEmail")
                UserDefaults.standard.removeObject(forKey: "userAddress")
                UserDefaults.standard.synchronize()

                let view = self?.storyboard?.instantiateViewController(withIdentifier: "EnteranceVC") as! EnteranceVC
                self?.navigationController?.pushViewController(view, animated: true)
        }
        else if (models.status == 0 ){
            JSSAlertView().danger(self!, title: "عذرا", text: models.arMsg, buttonText: "موافق")
        }

    }) { [weak self] (error) in
           JSSAlertView().danger(self!, title: "عذرا", text: "تأكد من اتصالك بالانترنت", buttonText: "موافق")
    }
   }

}
