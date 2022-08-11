//
//  addClientVC.swift
//  AL-HHALIL
//
//  Created by Sayed Abdo on 7/20/20.
//  Copyright © 2020 Sayed Abdo. All rights reserved.
//

import UIKit
import JSSAlertView
import TransitionButton
import DLRadioButton

class AddClientVC: UIViewController ,UITextFieldDelegate{

    //MARK: - IBOutlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var reasonNotActiveTextField: UITextField!
    

    
    @IBOutlet weak var stateDropDown: DropDown!
    @IBOutlet weak var branchDropDown: DropDown!
    
    @IBOutlet weak var activeButton: DLRadioButton!
    @IBOutlet weak var notActiveButton: DLRadioButton!
    
    @IBOutlet weak var addBtn: TransitionButton!
    
    @IBOutlet weak var reasonViewHeight: NSLayoutConstraint!
    @IBOutlet weak var reasonStack: UIStackView!
    
    //MARK: - Properties
    //
    var AllbranchArray = [BrancheDatum]()
    var branchArray = [String]()
    //
    var AllstateArray = [StatesDatum]()
    var stateArray = [String]()
    //
    var selectedState : String? = nil
    var selectedBranch : String? = nil
    var checkActive : String = ""
    var addNew = true
    
    var clientData: ClientDatum?
    
    //MARK: - View Controller Builder
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        config()
    }
    func config(){
        nameTextField.delegate = self
        emailTextField.delegate = self
        phoneTextField.delegate = self
        passwordTextField.delegate = self
        addressTextField.delegate = self
        reasonNotActiveTextField.delegate = self
        
        addBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left:0, bottom: 0, right:25)
        self.get_all_branche()
        self.get_all_status()
        if(addNew == true){
            activeButton.isSelected = true
            self.branchDropDown.isUserInteractionEnabled = false
            self.checkActive = "1"
            activeButton.isSelected = true
            reasonStack.isHidden = true
            reasonViewHeight.constant = 50
        }else{
            loadData()
           // passwordView.isHidden = true
            addBtn.titleLabel?.text = "حفظ التعديلات"
            self.branchDropDown.isUserInteractionEnabled = true
        }
        branchDropDown.placeholder = "حدد المنطقه اولا"
        self.stateDropDown.rowHeight = 50
        self.branchDropDown.rowHeight = 50
        self.stateDropDown.didSelect{(selectedText , index ,id) in
            //  self.dropDown.text = "Selected String: \(selectedText) \n index: \(index)"
            self.selectedState = self.AllstateArray[index].id
            self.branchDropDown.placeholder = "حدد فرع"
            self.branchDropDown.isEnabled = true
            self.branchDropDown.isUserInteractionEnabled = true
        }
        self.branchDropDown.didSelect{(selectedText , index ,id) in
            //  self.dropDown.text = "Selected String: \(selectedText) \n index: \(index)"
             self.selectedBranch = self.AllbranchArray[index].id
        }
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        self.getTokenReq()
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        let allowedCharacters = "1234567890"
//        let allowedCharacterSet = CharacterSet(charactersIn: allowedCharacters)
//        let typedCharacterSet = CharacterSet(charactersIn: string)
//        let alphabet = allowedCharacterSet.isSuperset(of: typedCharacterSet)
//        let maxLength = 9
//        let currentString: NSString = (textField.text ?? "") as NSString
//        let newString: NSString =
//            currentString.replacingCharacters(in: range, with: string) as NSString
//        return newString.length <= maxLength && alphabet
//    }
    // Add Client Or Edit Action
    @IBAction func saveButton(_ sender: UIButton) {
       validation()
    }
    // Radio Button Active Action
    @IBAction func activeAction(_ sender: DLRadioButton) {
        activeButton.isSelected = true
        checkActive = "1"
        reasonStack.isHidden = true
        reasonViewHeight.constant = 50
    }
    // Radio Button Not Active Action
    @IBAction func notActiveAction(_ sender: DLRadioButton) {
       notActiveButton.isSelected = true
       checkActive = "0"
       reasonStack.isHidden = false
       reasonViewHeight.constant = 100
    }
    func validation(){
        let EmailAddress = emailTextField.text
        let isEmailAddressValid = isValidEmailAddress(emailAddressString: EmailAddress!)
        if(nameTextField.text == ""){
            JSSAlertView().danger(self, title: "خطأ", text: "برجاء ادخال اسم العميل ", buttonText: "موافق")
        }else if(phoneTextField.text == ""){
            JSSAlertView().danger(self, title: "خطأ", text: "برجاء ادخال رقم الجوال", buttonText: "موافق")
        }else if(phoneTextField.text?.count != 9){
            JSSAlertView().danger(self, title: "خطأ", text: "برجاء ادخال رقم جوال مكون من ٩ رقم", buttonText: "موافق")
        }else if(passwordTextField.text!.count < 6){
            JSSAlertView().danger(self, title: "عذرا", text: "يجب ان يكون كلمة السر ٦ ارقام او اكثر", buttonText: "موافق")
        }else if(passwordTextField.text == ""){
             JSSAlertView().danger(self, title: "خطأ", text: "برجاء ادخال كلمه المرور", buttonText: "موافق")
        }else if(selectedState == nil){
            JSSAlertView().danger(self, title: "خطأ", text: "برجاء تحديد المنطقه التابع لها العميل", buttonText: "موافق")
        }else if(selectedBranch == nil){
            JSSAlertView().danger(self, title: "خطأ", text: "برجاء تحديد الفرع التابع لها العميل", buttonText: "موافق")
        }else if(addNew == true){
            add_clients()
        }else{
            edit_clients()
        }
    }
    func loadData(){
        nameTextField.text = clientData?.name
        emailTextField.text = clientData?.email
        let str = clientData?.phone
        let index = str?.index((str?.endIndex)!, offsetBy: -9)
        let mySubstring = str?.suffix(from: index!)
        print(mySubstring)
        phoneTextField.text = String(mySubstring!)
       
       // passwordTextField.text =
        addressTextField.text = clientData?.address
        reasonNotActiveTextField.text = clientData?.msg
        self.selectedState = clientData?.state
        self.selectedBranch = clientData?.branche
        if(clientData?.isActive == "1"){
            self.checkActive = "1"
            activeButton.isSelected = true
            reasonStack.isHidden = true
            reasonViewHeight.constant = 50
        }else{
            self.checkActive = "0"
            notActiveButton.isSelected = true
            reasonStack.isHidden = false
            reasonViewHeight.constant = 100
        }
    }
}
//MARK: -  Requestes in load
extension AddClientVC{
    func get_all_status(){
        NetworkClient.performRequest(States.self, router: .get_all_states, success: { [weak self] (models) in
                if(models.status == 1){
                  for statesCounter in models.data {
                    self?.stateArray.append(statesCounter.title)
                    self!.AllstateArray.append(StatesDatum(id: statesCounter.id, title: statesCounter.title))
                    if ( self?.clientData?.state == statesCounter.id){
                        self?.stateDropDown.text = statesCounter.title
                    }
                  }
                  self?.stateDropDown.optionArray = self?.stateArray ?? [""]
                  self?.stateDropDown.rowHeight = 50
                }
                else if (models.status == 0 ){
                    JSSAlertView().danger(self!, title: "عذرا", text: models.arMsg, buttonText: "موافق")
                }
        }){ [weak self] (error) in
            JSSAlertView().danger(self!, title: "عذرا", text: "تأكد من اتصالك بالانترنت", buttonText: "موافق")
          }
    }
    func get_all_branche(){
      NetworkClient.performRequest(Branche.self, router: .get_all_branches, success: { [weak self] (models) in
          if(models.status == 1){
            for branchCounter in models.data {
                self?.branchArray.append(branchCounter.title)
                self!.AllbranchArray.append(BrancheDatum(id: branchCounter.id, title: branchCounter.title, phone: branchCounter.phone, state: branchCounter.state, address: branchCounter.address))
                if ( self?.clientData?.branche == branchCounter.id){
                    self?.branchDropDown.text = branchCounter.title
                }
            }
            self?.branchDropDown.optionArray = self?.branchArray ?? [""]
            self?.branchDropDown.rowHeight = 50
          }
          else if (models.status == 0 ){
            JSSAlertView().danger(self!, title: "عذرا", text: "حدث حطأ ما حاول مره اخري", buttonText: "موافق")
          }
      }){ [weak self] (error) in
        JSSAlertView().danger(self!, title: "عذرا", text: "تأكد من اتصالك بالانترنت", buttonText: "موافق")
          }
    }
}
//MARK: - Requestes in actions
extension AddClientVC{
    func add_clients(){
        let formatter: NumberFormatter = NumberFormatter()
        formatter.locale = NSLocale(localeIdentifier: "EN") as Locale?
        let final = formatter.number(from: phoneTextField.text!)
        
        NetworkClient.performRequest(Client.self, router: .add_client(name: nameTextField.text!,
            email: emailTextField.text ?? "",phone: "966" + "\(final!)",password: passwordTextField.text!,users_group: "-1",branche: selectedBranch!,state: selectedState!,address: addressTextField.text ?? "",is_active: checkActive), success: { [weak self] (models) in
            if(models.status == 1){
                DispatchQueue.main.async(execute: { () -> Void in
                  self!.addBtn.stopAnimation(animationStyle: .normal, completion: {
                    JSSAlertView().success(self!,title: "حسنا",text: models.arMsg)
                        self?.navigationController?.popViewController(animated: true)
                  })
                })
            }
            else if (models.status == 0 ){
                JSSAlertView().danger(self!, title: "عذرا", text: models.arMsg, buttonText: "موافق")
            }
        }){ [weak self] (error) in
                JSSAlertView().danger(self!, title: "عذرا", text: "تأكد من اتصالك بالانترنت", buttonText: "موافق")
            }
    }
    func edit_clients(){
        let formatter: NumberFormatter = NumberFormatter()
        formatter.locale = NSLocale(localeIdentifier: "EN") as Locale?
        let final = formatter.number(from: phoneTextField.text!)
        
        NetworkClient.performRequest(Client.self, router: .edit_client(client_id: (clientData?.id)!,name: nameTextField.text!,email: emailTextField.text ?? "",phone: "966" + "\(final!)",users_group: "-1",branche: selectedBranch!,state: selectedState!,address: addressTextField.text ?? "",msg: reasonNotActiveTextField.text!,is_active: checkActive, password: passwordTextField.text ?? "", emp_id: (UserDefaults.standard.value(forKeyPath: "userId")! as? String)! ), success: { [weak self] (models) in
            if(models.status == 1){
                DispatchQueue.main.async(execute: { () -> Void in
                  self!.addBtn.stopAnimation(animationStyle: .normal, completion: {
                        JSSAlertView().success(self!,title: "حسنا",text: models.arMsg)
                        self?.navigationController?.popViewController(animated: true)
                  })
                })
            }
            else if (models.status == 0 ){
                JSSAlertView().danger(self!, title: "عذرا", text: models.arMsg, buttonText: "موافق")
            }
        }){ [weak self] (error) in
                JSSAlertView().danger(self!, title: "عذرا", text: "تأكد من اتصالك بالانترنت", buttonText: "موافق")
            }
    }
}
//MARK: - UITextFieldDelegate
extension AddClientVC{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if(textField == nameTextField){
            nameTextField.layer.borderColor = #colorLiteral(red: 0.4763007164, green: 0.2721414864, blue: 0.625670135, alpha: 0.8470588235) //your color
            nameTextField.layer.borderWidth = 1.0
        }else if(textField == emailTextField){
            emailTextField.layer.borderColor = #colorLiteral(red: 0.4763007164, green: 0.2721414864, blue: 0.625670135, alpha: 0.8470588235) //your color
            emailTextField.layer.borderWidth = 1.0
        }else if(textField == phoneTextField){
            phoneTextField.layer.borderColor = #colorLiteral(red: 0.4763007164, green: 0.2721414864, blue: 0.625670135, alpha: 0.8470588235) //your color
            phoneTextField.layer.borderWidth = 1.0
        }else if(textField == passwordTextField){
            passwordTextField.layer.borderColor = #colorLiteral(red: 0.4763007164, green: 0.2721414864, blue: 0.625670135, alpha: 0.8470588235) //your color
            passwordTextField.layer.borderWidth = 1.0
        }else if(textField == addressTextField){
            addressTextField.layer.borderColor = #colorLiteral(red: 0.4763007164, green: 0.2721414864, blue: 0.625670135, alpha: 0.8470588235) //your color
            addressTextField.layer.borderWidth = 1.0
        }else if(textField == reasonNotActiveTextField){
            reasonNotActiveTextField.layer.borderColor = #colorLiteral(red: 0.4763007164, green: 0.2721414864, blue: 0.625670135, alpha: 0.8470588235) //your color
            reasonNotActiveTextField.layer.borderWidth = 1.0
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if(textField == nameTextField){
            nameTextField.layer.borderWidth = 0.0
        }else if(textField == emailTextField){
            emailTextField.layer.borderWidth = 0.0
        }else if(textField == phoneTextField){
            phoneTextField.layer.borderWidth = 0.0
        }else if(textField == passwordTextField){
            passwordTextField.layer.borderWidth = 0.0
        }else if(textField == addressTextField){
            addressTextField.layer.borderWidth = 0.0
        }else if(textField == reasonNotActiveTextField){
            reasonNotActiveTextField.layer.borderWidth = 0.0
        }
    }
    //
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(textField == nameTextField){
            textField.resignFirstResponder()
            emailTextField.becomeFirstResponder()
        }else if(textField == emailTextField){
            textField.resignFirstResponder()
            phoneTextField.becomeFirstResponder()
        }else if(textField == phoneTextField){
            textField.resignFirstResponder()
            if(addNew == true){
                passwordTextField.becomeFirstResponder()
            }else{
                addressTextField.becomeFirstResponder()
            }
        }else if(textField == passwordTextField){
            textField.resignFirstResponder()
            addressTextField.becomeFirstResponder()
        }else if(textField == addressTextField){
            self.view.endEditing(true)
        }else if(textField == reasonNotActiveTextField){
            self.view.endEditing(true)
        }
        return true
    }
}
