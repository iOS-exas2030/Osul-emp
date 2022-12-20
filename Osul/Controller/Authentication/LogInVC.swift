//
//  ViewController.swift
//  AL-KHALIL
//
//  Created by Sayed Abdo && Aya Bahaa on 7/2/20.
//  Copyright © 2020 Sayed Abdo && Aya Bahaa. All rights reserved.
//

import UIKit
import JSSAlertView
import TransitionButton
import Toast_Swift
import NVActivityIndicatorView
import Firebase
import FirebaseAuth

class LogInVC: UIViewController , UITextFieldDelegate {
    
    //MARK: - IBOutlets
    @IBOutlet weak var MainContainerView: UIView!
    @IBOutlet weak var userNameTextField: SkyFloatingLabelTextFieldWithIcon!
    
    @IBOutlet weak var createAccount: TransitionButton!
    @IBOutlet weak var loginButton: TransitionButton!
    @IBOutlet weak var PassWordTextField: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var checkBoxView: UIView!
    @IBOutlet weak var checkBoxImage: UIImageView!
    @IBOutlet weak var phoneView: UIView!
    
    //MARK: - Properties
    let defaults = UserDefaults.standard
    var login : LoginModel?
    var rememberMe = false
    var group = [Group]()
    var check = false
   
    //MARK: - View Controller Builder
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        config()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        tryDelete()
        
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height - 100
            }
        }
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    func config(){
        checkBoxImage.isHidden = true
        let checkBoxTap = UITapGestureRecognizer(target: self, action: #selector(LogInVC.checkBoxAction))
        checkBoxView.addGestureRecognizer(checkBoxTap)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        userNameTextField.delegate = self
        PassWordTextField.delegate = self
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    ///function on eye image to remmber me
    
    @objc func checkBoxAction(){
        if checkBoxImage.isHidden == true {
            checkBoxImage.isHidden = false
            rememberMe = true
        }else{
            checkBoxImage.isHidden = true
            rememberMe = false
        }
    }
    // forget password Action
    @IBAction func forgetPassword(_ sender: UIButton) {
        let view = storyboard?.instantiateViewController(withIdentifier: "ForgetPasswordVC") as! ForgetPasswordVC
        self.navigationController?.pushViewController(view, animated: true)
    }
    
    @IBAction func createAccountAction(_ sender: Any) {
        let view = storyboard?.instantiateViewController(withIdentifier: "addEmployeVC") as! addEmployeVC
        view.check = false
        self.present(view, animated: true, completion: nil)
    }
    // Login Action
    @IBAction func LoginAction(_ sender: Any) {
        if(userNameTextField.text == ""){
            JSSAlertView().danger(self, title: "خطأ", text: "برجاء ادخال اسم المستخدم أولا ", buttonText: "موافق")
        }else if(PassWordTextField.text == ""){
             JSSAlertView().danger(self, title: "خطأ", text: "برجاء ادخال كلمه المرور أولا ", buttonText: "موافق")
        }else if(userNameTextField.text?.count != 9){
            JSSAlertView().danger(self, title: "عذرا", text: "ادخل رقم الهاتف مكون من ٩ رقم", buttonText: "موافق")
        }else if(PassWordTextField.text!.count < 6){
            JSSAlertView().danger(self, title: "عذرا", text: "يجب ان يكون كلمة السر ٦ ارقام او اكثر", buttonText: "موافق")
        }else{
            loginButton.startAnimation()
            let formatter: NumberFormatter = NumberFormatter()
            formatter.locale = NSLocale(localeIdentifier: "EN") as Locale?
            let final = formatter.number(from: userNameTextField.text!)
            login(username: "966" + "\(final!)" , password: PassWordTextField.text  ?? "")
        }
    }

    
    @IBAction func virsionInfo(_ sender: Any) {
        self.view.makeToast("Osul-EMP Version 1.0(1)", duration: 5.0, position: .bottom)
    }
    
    @IBAction func passwordView(_ sender: UIButton) {
        if check {
            PassWordTextField.isSecureTextEntry = true
            sender.setImage(UIImage(named: "HidePassword"), for: .normal)
            check = false
        }
        else {
            PassWordTextField.isSecureTextEntry = false
            sender.setImage(UIImage(named: "ShowPassword"), for: .normal)
            check = true
        }
    }
}

//MARK: - UITextFieldDelegate
extension LogInVC{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if(textField == userNameTextField){
            phoneView.layer.borderColor = #colorLiteral(red: 0.3960784314, green: 0.1843137255, blue: 0.5568627451, alpha: 1) //your color
            phoneView.layer.borderWidth = 1.0
        }else if(textField == PassWordTextField){
            PassWordTextField.layer.borderColor = #colorLiteral(red: 0.3960784314, green: 0.1843137255, blue: 0.5568627451, alpha: 1) //your color
            PassWordTextField.layer.borderWidth = 1.0
        }
    }
    //
    func textFieldDidEndEditing(_ textField: UITextField) {
        if(textField == userNameTextField){
            phoneView.layer.borderWidth = 0.0
        }else if(textField == PassWordTextField){
            PassWordTextField.layer.borderWidth = 0.0
        }
    }
    //
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(textField == userNameTextField){
            textField.resignFirstResponder()
            PassWordTextField.becomeFirstResponder()
        }else if(textField == PassWordTextField){
            self.view.endEditing(true)
        }
        return true
    }
}
//MARK: - Request
extension LogInVC{
    // login function that connect with server
    func login(username : String , password : String) {
        
      if Reachability.connectedToNetwork() {
        let qualityOfServiceClass = DispatchQoS.QoSClass.background
        let backgroundQueue = DispatchQueue.global(qos: qualityOfServiceClass)        
        backgroundQueue.async(execute: {
            
            NetworkClient.performRequest(LoginModel.self, router: .login(username: username, password: password), success: { [weak self] (models) in
                     self?.login = models
                     print("models\( models)")
                if(models.status == 1){
                let model = models.data?[0].userDetails?[0].id
                    self?.defaults.set(model, forKey: "userId")
                       // Constants.userId.set(model, forKey: "userId")
                        self?.defaults.set(self!.rememberMe, forKey: "rememberMe")
                        self?.defaults.set(models.data?[0].userDetails?[0].name ?? "", forKey: "userName")
                        self?.defaults.set(models.data?[0].userDetails?[0].phone ?? "", forKey: "userPhone")
                        self?.defaults.set(models.data?[0].userDetails?[0].email ?? "", forKey: "userEmail")
                        self?.defaults.set(models.data?[0].userDetails?[0].address ?? "", forKey: "userAddress")
                        self?.group = (models.data?[0].userGroup)!
                        //isContracting, isProjects, isReport, isFinancial,isClientOrder,isSettings
                        self?.defaults.set(models.data?[0].userGroup?[0].isContracting ?? "", forKey: "isContracting")
                        self?.defaults.set(models.data?[0].userGroup?[0].isProjects ?? "", forKey: "isProjects")
                        self?.defaults.set(models.data?[0].userGroup?[0].isReport ?? "", forKey: "isReport")
                        self?.defaults.set(models.data?[0].userGroup?[0].isFinancial ?? "", forKey: "isFinancial")
                        self?.defaults.set(models.data?[0].userGroup?[0].isClientOrder ?? "", forKey: "isClientOrder")
                        self?.defaults.set(models.data?[0].userGroup?[0].isSettings ?? "", forKey: "isSettings")
                        self?.defaults.set(models.data?[0].userGroup?[0].isProgressTime ?? "", forKey: "isProgressTime")
                        self?.defaults.set(models.data?[0].userDetails?[0].jopType ?? "", forKey: "jopType")
                        self?.defaults.set(models.data?[0].userGroup?[0].title ?? "", forKey: "jopTitle")
                        self?.sendToken()
                        if models.data?[0].userDetails?[0].firebase == "0" {
                            self?.firebase(id: (models.data?[0].userDetails?[0].id)!)
                            var id = models.data?[0].userDetails?[0].id
                            self?.createUser(id: (models.data?[0].userDetails?[0].id)!, name: models.data?[0].userDetails?[0].name ?? "", email: id! + "_user@gmail.com", password: id! + "_user", jobType: models.data?[0].userDetails?[0].jopType ?? "")
                        
                        }else if models.data?[0].userDetails?[0].firebase == "1"{
                            // self?.loginFireBase(email: models.data?[0].userDetails?[0].phone ?? "", password: models.data?[0].userDetails?[0].password ?? "")
                            var id = models.data?[0].userDetails?[0].id
                            self?.loginFireBase(email: id! + "_user@gmail.com", password: id! + "_user" )
                        }
                        
                }
                else if (models.status == 0 ){
                        DispatchQueue.main.async(execute: { () -> Void in
                            self!.loginButton.stopAnimation(animationStyle: .shake, completion: {
                                JSSAlertView().danger(self!, title: "خطأ", text: models.arMsg, buttonText: "موافق")
                        })
                    })
                }
                else if (models.status == 2 ){
                        DispatchQueue.main.async(execute: { () -> Void in
                            self!.loginButton.stopAnimation(animationStyle: .shake, completion: {
                                JSSAlertView().warning(self!, title: "الحساب معطل", text: models.arMsg, buttonText: "موافق")
                        })
                    })
                }
                }){ [weak self] (error) in
                      DispatchQueue.main.async(execute: { () -> Void in
                        self!.loginButton.stopAnimation(animationStyle: .shake, completion: {
                        JSSAlertView().danger(self!, title: "عذرا", text: "حدث خطأ ما ", buttonText: "حاول لاحقا")
                            })
                        })
                    }
                })
            }else{
                DispatchQueue.main.async(execute: { () -> Void in
                    self.loginButton.stopAnimation(animationStyle: .shake, completion: {
                        JSSAlertView().danger(self, title: "عذرا", text: "تأكد من اتصالك بالانترنت", buttonText: "موافق")
                    })
                })
        }
        
    }
    func firebase(id:String){
            NetworkClient.performRequest(FirebaseModel.self, router: .fireBase_Type(user_id: id), success: { [weak self] (models) in
                   
                 if(models.status == 1){
                     print("success")
                 }
                 else if (models.status == 0 ){
                     print("errorrr")
                    JSSAlertView().danger(self!, title: "خطأ", text: "كلمة التحقق غير صحيحة", buttonText: "موافق")
                 }
             }){ [weak self] (error) in
                    JSSAlertView().danger(self!, title: "عذرا", text: "تأكد من اتصالك بالانترنت", buttonText: "موافق")
               }
     }
     func loginFireBase(email: String, password :String) {

        Auth.auth().signIn(withEmail:  email, password: password) { [weak self] authResult, error in
            print("uid\(authResult?.user.uid)")
      //  guard let strongSelf = self else { return }
       // [START_EXCLUDE]
         print("loginUser")
         if  error == nil {
             print(error)
         }else{
              print("Error \(error)")
       // [END_EXCLUDE]
         }
       }
     }
     func createUser( id :String, name: String ,email : String , password : String, jobType: String){
            Auth.auth().createUser(withEmail: email, password: password)
            { authResult, error in
                if(authResult?.user != nil)
                {
                    var data = ["id": id , "jop_type" :jobType, "name" : name]
                Constants.refs.databaseUser.child("Employee").child((authResult?.user.uid)!).setValue(data)
                  self.defaults.set(authResult?.user.uid, forKey: "id")
                    print("createUser")
                } else
                {
                    print("error y m3lm\(error)")
                }
            }
      }
    func sendToken(){
      //  let token = UserDefaults.standard.value(forKeyPath: "token") as? String
        NetworkClient.performRequest(tokenModel.self, router: .edit_user_token(user_id: login?.data?[0].userDetails?[0].id ?? "", token_id:  AppDelegate.token ?? ""), success: { [weak self] (models) in

            print("models ayaaaaaaaaaaa\( AppDelegate.token ?? "")")
            if(models.status == 1){
                 print("good")
                 self?.defaults.set(AppDelegate.token ?? "", forKey: "Token")
                 self?.updateRoot()
            }
            else if (models.status == 0 ){
                print("errorrr")
                JSSAlertView().danger(self!, title: "خطأ", text: "حدث حطأ ما", buttonText: "حاول مره اخري")
            }
        }){ [weak self] (error) in
           
            }
     }
    
     func tryDelete(){
            UserDefaults.standard.removeObject(forKey: "userId")
            UserDefaults.standard.removeObject(forKey: "rememberMe")
            UserDefaults.standard.removeObject(forKey: "userName")
            UserDefaults.standard.removeObject(forKey: "userPhone")
            UserDefaults.standard.removeObject(forKey: "userEmail")
            UserDefaults.standard.removeObject(forKey: "userAddress")
            UserDefaults.standard.removeObject(forKey: "isContracting")
            UserDefaults.standard.removeObject(forKey: "isProjects")
            UserDefaults.standard.removeObject(forKey: "isReport")
            UserDefaults.standard.removeObject(forKey: "isFinancial")
            UserDefaults.standard.removeObject(forKey: "isClientOrder")
            UserDefaults.standard.removeObject(forKey: "isSettings")
            UserDefaults.standard.removeObject(forKey: "isProgressTime")
            UserDefaults.standard.removeObject(forKey: "jopType")
            UserDefaults.standard.removeObject(forKey: "jopTitle")
            
            let domain = Bundle.main.bundleIdentifier!
            UserDefaults.standard.removePersistentDomain(forName: domain)
            UserDefaults.standard.synchronize()
            UserDefaults.standard.reset()
            
            UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
            
            if let appDomain = Bundle.main.bundleIdentifier {
                UserDefaults.standard.removePersistentDomain(forName: appDomain)
            }
            resetDefaults()
            resetUserDefaults1()
            UserDefaults.standard.synchronize()
            UserDefaults.resetStandardUserDefaults()
            UserDefaults.standard.synchronize()
            print("qqqq : \(Array(UserDefaults.standard.dictionaryRepresentation().keys).count)")
    }
    func resetDefaults() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
    }
    func resetUserDefaults1(){

        let userDefaults = UserDefaults.standard
        let dict = userDefaults.dictionaryRepresentation() as NSDictionary

        for key in dict.allKeys {
            userDefaults.removeObject(forKey: key as! String)
        }
        userDefaults.synchronize()
     }

}
