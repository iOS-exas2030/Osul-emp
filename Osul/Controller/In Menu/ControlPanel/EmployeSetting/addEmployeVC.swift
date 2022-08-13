//
//  addEmployeVC.swift
//  AL-HHALIL
//
//  Created by apple on 7/22/20.
//  Copyright © 2020 Sayed Abdo. All rights reserved.
//

import UIKit
import JSSAlertView
import TransitionButton
import DLRadioButton

class addEmployeVC: BaseVC ,UITextFieldDelegate{
    
    //MARK: - IBOutlets
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var reasonNotActive: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var name: UITextField!
    
    @IBOutlet weak var state: DropDown!
    @IBOutlet weak var branch: DropDown!
    @IBOutlet weak var userGroups: DropDown!
    @IBOutlet weak var jobType: DropDown!
    
    @IBOutlet weak var activeButton: DLRadioButton!
    @IBOutlet weak var notActiveButton: DLRadioButton!
        
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var saveChangeBtn: TransitionButton!
    @IBOutlet weak var editOrDeleteStack: UIStackView!
    
    @IBOutlet weak var addBtn: TransitionButton!
    
    @IBOutlet weak var reasonViewHeight: NSLayoutConstraint!
    @IBOutlet weak var reasonStack: UIStackView!
    
    @IBOutlet weak var mainScrollView : UIScrollView!
    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var stateView: UIView!
    @IBOutlet weak var branchView: UIView!
    
    
    //MARK: - Properties
    var selectedState : String? = "0"
    var selectedBranch : String? = "0"
    var selectedUserGroups : String? = nil
    var selectedJobType : String = ""
    var checkActive : String = ""
    
    var id = ""
    var addNew = true
    var users: Employee?
    var all_branche : Branche?
    var all_states : States?
    var all_users_groups : UserGroup?
    var employeData :  EmployeeDatum?
    //
    var AllUserGroupArray = [UserGroupDatum]()
    var userGroupsArray = [String]()
    //
    var AllbranchArray = [BrancheDatum]()
    var branchArray = [String]()
    //
    var AllstateArray = [StatesDatum]()
    var stateArray = [String]()
    
    //status views
    var loaderView = UIView()
    var noDataView = UIView()
    var refresDatahBtn = TransitionButton()
    var refreshInterNetBtn = TransitionButton()
    var noInterNetView = UIView()
    var errorView = UIView()
    var refreshErrorBtn = TransitionButton()
    var addFBtn = TransitionButton()
    var check = true
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        config()
    }
    func config(){
        addAllViews()
        addBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left:0, bottom: 0, right:25)
        saveChangeBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left:0, bottom: 0, right:25)
        deleteBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left:0, bottom: 0, right:25)
        
        address.delegate = self
        reasonNotActive.delegate = self
        password.delegate = self
        phone.delegate = self
        email.delegate = self
        name.delegate = self
        if check == false {
            
        }
        
        if(addNew == true){
            editOrDeleteStack.isHidden = true
            self.get_all_branche()
            self.get_all_status()
            self.get_all_users_groups()
            branch.isUserInteractionEnabled = false
            reasonStack.isHidden = true
            reasonViewHeight.constant = 50
            activeButton.isSelected = true
            checkActive = "1"
            self.hideAllViews()
        }else{
            addBtn.isHidden = true
            get_employee_info()
            passwordView.isHidden = true
            branch.isUserInteractionEnabled = true
        }
        branch.placeholder = "حدد المنطقه اولا"
        self.state.rowHeight = 50
        self.branch.rowHeight = 50
        self.userGroups.rowHeight = 50
        self.jobType.rowHeight = 50
        
        self.state.didSelect{(selectedText , index ,id) in
            //  self.dropDown.text = "Selected String: \(selectedText) \n index: \(index)"
            self.selectedState = self.all_states?.data[index].id
            self.branch.isUserInteractionEnabled = true
            self.branch.placeholder = "حدد فرع"
        }
        self.branch.didSelect{(selectedText , index ,id) in
            //  self.dropDown.text = "Selected String: \(selectedText) \n index: \(index)"
             self.selectedBranch = self.all_branche?.data[index].id
        }
        self.userGroups.didSelect{(selectedText , index ,id) in
            //  self.dropDown.text = "Selected String: \(selectedText) \n index: \(index)"
             self.selectedUserGroups = self.all_users_groups?.data[index].id
        }
        self.jobType.didSelect{(selectedText , index ,id) in
            //  self.dropDown.text = "Selected String: \(selectedText) \n index: \(index)"
            self.selectedJobType = String(index + 1)
            if selectedText == "مشروع محدد"{
                self.selectedJobType == "1"
            }else if selectedText ==  "فرع محدد"{
                self.selectedJobType == "2"
            }else if selectedText == "كل الفروع" {
                self.selectedJobType == "3"
            }
            
            if(self.selectedJobType == "3"){
                self.stateView.isHidden = true
                self.branchView.isHidden = true
                print("true 3")
            }else{
                self.stateView.isHidden = false
                self.branchView.isHidden = false
                print("false 3")
            }
        }
       // self.jobType.optionArray = [ "موظف عام","مدير عام الفرع","مدير عام الفروع"]
        self.jobType.optionArray = ["مشروع محدد","فرع محدد","كل الفروع"]
        
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
    @IBAction func deleteButton(_ sender: UIButton) {
        let alertview = JSSAlertView().warning(self,title: "تنبيه !",text: "هل تريد حذف الموظف ؟",
                        buttonText: "موافق",cancelButtonText: "إلغاء" )
        alertview.addAction {
            self.remove_employee_info(id: self.id)
        }
        alertview.addCancelAction {
            print("cancel")
        }
    }
    @IBAction func saveButton(_ sender: UIButton) {
        validation()
    }
    @IBAction func addNewAction(_ sender: Any) {
        validation()
    }
    @IBAction func activeAction(_ sender: DLRadioButton) {
        activeButton.isSelected = true
        checkActive = "1"
        reasonStack.isHidden = true
        reasonViewHeight.constant = 50
    }
    @IBAction func notActiveAction(_ sender: DLRadioButton) {
        notActiveButton.isSelected = true
        checkActive = "0"
        reasonStack.isHidden = false
        reasonViewHeight.constant = 100
    }
    func validation(){
        let EmailAddress = email.text
        let isEmailAddressValid = isValidEmailAddress(emailAddressString: EmailAddress!)
        if(name.text == ""){
            JSSAlertView().danger(self, title: "خطأ", text: "برجاء ادخال اسم الموظف ", buttonText: "موافق")
        }else if(email.text == ""){
            JSSAlertView().danger(self, title: "خطأ", text: "برجاء ادخال البريد الإلكترونى ", buttonText: "موافق")
        }else if !isEmailAddressValid
            {
                JSSAlertView().danger(self,title: "خطأ",text: "برجاء كتابه البريد الالكترونى صحيحا",buttonText: "موافق")
                return
        }else if(phone.text == ""){
            JSSAlertView().danger(self, title: "خطأ", text: "برجاء ادخال رقم الجوال", buttonText: "موافق")
        }else if(phone.text?.count != 9){
            JSSAlertView().danger(self, title: "خطأ", text: "برجاء ادخال رقم جوال مكون من ٩ رقم", buttonText: "موافق")
        }else if(password.text!.count < 6 && addNew == true){
                JSSAlertView().danger(self, title: "عذرا", text: "يجب ان يكون كلمة السر ٦ ارقام او اكثر", buttonText: "موافق")
        }else if(address.text == ""){
            JSSAlertView().danger(self, title: "خطأ", text: "برجاء ادخال رقم العنوان", buttonText: "موافق")
        }else if(addNew == true && password.text == ""){
            JSSAlertView().danger(self, title: "خطأ", text: "برجاء ادخال كلمه المرور", buttonText: "موافق")
        }else if(selectedJobType == ""){
            JSSAlertView().danger(self, title: "خطأ", text: "برجاء تحديد نوع الوظيفه", buttonText: "موافق")
        }else if(selectedUserGroups == nil){
            JSSAlertView().danger(self, title: "خطأ", text: "برجاء تحديد صلاحيات الموظف", buttonText: "موافق")
        }else if(selectedState == "0" && self.selectedJobType != "3"){
            JSSAlertView().danger(self, title: "خطأ", text: "برجاء تحديد المنطقه التابع لها الموظف", buttonText: "موافق")
        }else if(selectedBranch == "0" && self.selectedJobType != "3"){
            JSSAlertView().danger(self, title: "خطأ", text: "برجاء تحديد الفرع التابع له الموظف", buttonText: "موافق")
        }else if(checkActive == "0" && reasonNotActive.text == ""){
            JSSAlertView().danger(self, title: "خطأ", text: "برجاء ادخال سبب التعطيل", buttonText: "موافق")
        }else{
            if(addNew == true){
               addBtn.startAnimation()
               let alertview = JSSAlertView().info(self,title: "تنبيه !",text: "هل تريد تاكيد الإضافه؟",
                               buttonText: "موافق",cancelButtonText: "إلغاء" )
               alertview.addAction {
                   self.add_employee_info()
               }
               alertview.addCancelAction {
                   self.addBtn.stopAnimation()
               }
            }else{
                addBtn.startAnimation()
                let alertview = JSSAlertView().info(self,title: "تنبيه !",text: "هل تريد حفظ التعديلات ؟",
                                buttonText: "موافق",cancelButtonText: "إلغاء" )
                alertview.addAction {
                    self.edit_employee_info()
                }
                alertview.addCancelAction {
                    self.addBtn.stopAnimation()
                }
            }
        }
    }
}
//MARK: - UITextFieldDelegate
extension addEmployeVC{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if(textField == name){
            name.layer.borderColor = #colorLiteral(red: 0.4763007164, green: 0.2721414864, blue: 0.625670135, alpha: 0.8470588235) //your color
            name.layer.borderWidth = 1.0
        }else if(textField == email){
            email.layer.borderColor = #colorLiteral(red: 0.4763007164, green: 0.2721414864, blue: 0.625670135, alpha: 0.8470588235) //your color
            email.layer.borderWidth = 1.0
        }else if(textField == phone){
            phone.layer.borderColor = #colorLiteral(red: 0.4763007164, green: 0.2721414864, blue: 0.625670135, alpha: 0.8470588235) //your color
            phone.layer.borderWidth = 1.0
        }else if(textField == password){
            password.layer.borderColor = #colorLiteral(red: 0.4763007164, green: 0.2721414864, blue: 0.625670135, alpha: 0.8470588235) //your color
            password.layer.borderWidth = 1.0
        }else if(textField == reasonNotActive){
            reasonNotActive.layer.borderColor = #colorLiteral(red: 0.4763007164, green: 0.2721414864, blue: 0.625670135, alpha: 0.8470588235) //your color
            reasonNotActive.layer.borderWidth = 1.0
        }else if(textField == address){
            address.layer.borderColor = #colorLiteral(red: 0.4763007164, green: 0.2721414864, blue: 0.625670135, alpha: 0.8470588235) //your color
            address.layer.borderWidth = 1.0
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if(textField == name){
            name.layer.borderWidth = 0.0
        }else if(textField == email){
            email.layer.borderWidth = 0.0
        }else if(textField == phone){
            phone.layer.borderWidth = 0.0
        }else if(textField == password){
            password.layer.borderWidth = 0.0
        }else if(textField == reasonNotActive){
            reasonNotActive.layer.borderWidth = 0.0
        }else if(textField == address){
            address.layer.borderWidth = 0.0
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(textField == name){
            textField.resignFirstResponder()
            email.becomeFirstResponder()
        }else if(textField == email){
            textField.resignFirstResponder()
            phone.becomeFirstResponder()
        }else if(textField == phone){
            textField.resignFirstResponder()
            if(addNew == true){
                password.becomeFirstResponder()
            }else{
                address.becomeFirstResponder()
            }
        }else if(textField == password){
            textField.resignFirstResponder()
            address.becomeFirstResponder()
        }else if(textField == address){
             self.view.endEditing(true)
        }else if(textField == reasonNotActive){
            self.view.endEditing(true)
        }
        return true
    }
}
//MARK: -Request
extension addEmployeVC{
    @objc func get_employee_info(){
        startAllAnimationBtn()
        if Reachability.connectedToNetwork() {
            NetworkClient.performRequest(Employee.self, router: .get_user_info(id: id), success: { [weak self] (models) in
                self?.users = models
                if(models.status == 1){
                    self?.name.text = self?.users?.data[0].name
                    self?.email.text = self?.users?.data[0].email
                    let str = self?.users?.data[0].phone
                    let index = str?.index((str?.endIndex)!, offsetBy: -9)
                    let mySubstring = str?.suffix(from: index!)
                    print(mySubstring)
                    self?.phone.text = String(mySubstring!)
                 
                    self?.address.text = self?.users?.data[0].address
                  //  let job = self?.users?.data[0].jopType
                    if self?.users?.data[0].jopType == "1" {
                         self?.jobType.text = "مشروع محدد"
                    }else if self?.users?.data[0].jopType == "2"{
                        self?.jobType.text = "فرع محدد"
                    }else if self?.users?.data[0].jopType == "3"{
                        self?.jobType.text = "كل الفروع"
                        self?.stateView.isHidden = true
                        self?.branchView.isHidden = true
                    }
                    self?.checkActive = (self?.users?.data[0].isActive)!
                    if self?.users?.data[0].isActive == "1"{
                        self?.checkActive = "1"
                        self?.activeButton.isSelected = true
                        self!.reasonStack.isHidden = true
                        self!.reasonViewHeight.constant = 50
                    }else if self?.users?.data[0].isActive == "0"{
                        self?.checkActive = "0"
                        self?.notActiveButton.isSelected = true
                        self?.reasonStack.isHidden = false
                        self?.reasonViewHeight.constant = 100
                        self?.reasonNotActive.text = self?.users?.data[0].msg
                    }
                    self?.get_all_branche()
                    self?.get_all_status()
                    self?.get_all_users_groups()
                    self?.selectedState = self?.users?.data[0].state
                    self?.selectedBranch = self?.users?.data[0].branche
                    self?.selectedUserGroups = self?.users?.data[0].usersGroup
                    self?.selectedJobType = (self?.users?.data[0].jopType)!
                    self!.hideAllViews()
                }else if (models.status == 0 ){
                     self!.hideAllViews()
                     self!.noDataView.isHidden = false
                     self?.refresDatahBtn.addTarget(self, action: #selector(self?.get_employee_info), for: UIControl.Event.touchUpInside)
                }
            }){ [weak self] (error) in
                    self!.hideAllViews()
                    self!.errorView.isHidden = false
                    self?.refreshErrorBtn.addTarget(self, action: #selector(self?.get_employee_info), for: UIControl.Event.touchUpInside)
            }
        }else{
                    hideAllViews()
                    noInterNetView.isHidden = false
                    self.refreshInterNetBtn.addTarget(self, action: #selector(self.get_employee_info), for: UIControl.Event.touchUpInside)
            }
    }
    func get_all_branche(){
      NetworkClient.performRequest(Branche.self, router: .get_all_branches, success: { [weak self] (models) in
          self?.all_branche = models
          if(models.status == 1){
            for branchCounter in models.data {
                self?.branchArray.append(branchCounter.title)
                self!.AllbranchArray.append(BrancheDatum(id: branchCounter.id, title: branchCounter.title, phone: branchCounter.phone, state: branchCounter.state, address: branchCounter.address))
                if ( self?.users?.data[0].branche == branchCounter.id){
                    self?.branch.text = branchCounter.title
                }
                
            }
            self?.branch.optionArray = self?.branchArray ?? [""]
            self?.branch.rowHeight = 50
          }
          else if (models.status == 0 ){
            JSSAlertView().danger(self!, title: "عذرا", text: "حدث حطأ ما حاول مره اخري", buttonText: "موافق")
          }
      }){ [weak self] (error) in
            JSSAlertView().danger(self!, title: "عذرا", text: "تأكد من اتصالك بالانترنت", buttonText: "موافق")
          }
    }
    func get_all_status(){
        NetworkClient.performRequest(States.self, router: .get_all_states, success: { [weak self] (models) in
                self?.all_states = models
                if(models.status == 1){
                  for statesCounter in models.data {
                    self?.stateArray.append(statesCounter.title)
                    self!.AllstateArray.append(StatesDatum(id: statesCounter.id, title: statesCounter.title))
                    if ( self?.users?.data[0].state == statesCounter.id){
                        self?.state.text = statesCounter.title
                    }
                  }
                    self?.state.optionArray = self?.stateArray ?? [""]
                    self?.state.rowHeight = 50
                }
                else if (models.status == 0 ){
                    JSSAlertView().danger(self!, title: "عذرا", text: "حدث حطأ ما حاول مره اخري", buttonText: "موافق")
                }
        }){ [weak self] (error) in
                JSSAlertView().danger(self!, title: "عذرا", text: "تأكد من اتصالك بالانترنت", buttonText: "موافق")
            }
    }
    func get_all_users_groups(){
        NetworkClient.performRequest(UserGroup.self, router: .get_all_users_groups, success: { [weak self] (models) in
            self?.all_users_groups = models
            if(models.status == 1){
              for userGroupsCounter in models.data {
                self?.userGroupsArray.append(userGroupsCounter.title)
                self!.AllUserGroupArray.append(UserGroupDatum(id: userGroupsCounter.id, title: userGroupsCounter.title, type: userGroupsCounter.type, isClientOrder: userGroupsCounter.isClientOrder, isContracting: userGroupsCounter.isContracting, isProjects: userGroupsCounter.isProjects, isReport: userGroupsCounter.isReport, isFinancial: userGroupsCounter.isFinancial, isSettings: userGroupsCounter.isSettings,isProgressTime:userGroupsCounter.isProgressTime ))
                
                if ( self?.users?.data[0].usersGroup  == userGroupsCounter.id){
                    self?.userGroups.text = userGroupsCounter.title
                }
              }
                self?.userGroups.optionArray = self?.userGroupsArray ?? [""]
                self?.userGroups.rowHeight = 50
            }else if (models.status == 0 ){
                JSSAlertView().danger(self!, title: "عذرا", text: "حدث حطأ ما حاول مره اخري", buttonText: "موافق")
            }
        }){ [weak self] (error) in
            JSSAlertView().danger(self!, title: "عذرا", text: "تأكد من اتصالك بالانترنت", buttonText: "موافق")
            }
    }
    func add_employee_info(){
          addBtn.startAnimation()
         if(checkActive == "1"){
            reasonNotActive.text! = ""
         }
         if(self.selectedJobType == "3"){
            selectedState = "0"
            selectedBranch = "0"
         }
        
         let formatter: NumberFormatter = NumberFormatter()
         formatter.locale = NSLocale(localeIdentifier: "EN") as Locale?
         let final = formatter.number(from: phone.text!)
        
          NetworkClient.performRequest(Employee.self, router: .add_user(name: name.text!,email: email.text!,phone: "966" + "\(final!)",password: password.text!,jop_type: selectedJobType,users_group: selectedUserGroups!,branche: selectedBranch!,state: selectedState!,address: address.text!,is_active: checkActive,msg: reasonNotActive.text!), success: { [weak self] (models) in
                    if(models.status == 1){
                        DispatchQueue.main.async(execute: { () -> Void in
                          self!.addBtn.stopAnimation(animationStyle: .normal, completion: {
                                JSSAlertView().success(self!,title: "حسنا",text: "تم الحفظ بنجاح")
                            self?.navigationController?.popViewController(animated: true)
                          })
                        })
                    }
                    else if (models.status == 0 ){
                        DispatchQueue.main.async(execute: { () -> Void in
                                self!.addBtn.stopAnimation(animationStyle: .shake, completion: {
                                JSSAlertView().danger(self!, title: "عذرا", text: models.arMsg, buttonText: "موافق")
                            })
                        })
                    }
                }){ [weak self] (error) in
                    DispatchQueue.main.async(execute: { () -> Void in
                        self!.addBtn.stopAnimation(animationStyle: .shake, completion: {
                            JSSAlertView().danger(self!, title: "عذرا", text: "تأكد من اتصالك بالانترنت", buttonText: "موافق")
                        })
                    })
               }
    }
    func edit_employee_info(){
        saveChangeBtn.startAnimation()
        if(checkActive == "1"){
            reasonNotActive.text! = ""
        }
        if(self.selectedJobType == "3"){
           selectedState = "0"
           selectedBranch = "0"
        }
        let formatter: NumberFormatter = NumberFormatter()
        formatter.locale = NSLocale(localeIdentifier: "EN") as Locale?
        let final = formatter.number(from: phone.text!)
        NetworkClient.performRequest(Employee.self, router: .edit_user(user_id: id,name: name.text!,email: email.text!,phone: "966" + "\(final!)",jop_type: selectedJobType,users_group: selectedUserGroups!,branche: selectedBranch!,state: selectedState!,address: address.text!,is_active: checkActive,msg: reasonNotActive.text!),
            success: { [weak self] (models) in
             if(models.status == 1){
                DispatchQueue.main.async(execute: { () -> Void in
                  self!.saveChangeBtn.stopAnimation(animationStyle: .normal, completion: {
                        JSSAlertView().success(self!,title: "حسنا",text: "تم التعديل بنجاح")
                        self?.navigationController?.popViewController(animated: true)
                        
                  })
                })
             }
             else if (models.status == 0 ){
                DispatchQueue.main.async(execute: { () -> Void in
                        self!.saveChangeBtn.stopAnimation(animationStyle: .shake, completion: {
                            JSSAlertView().danger(self!, title: "عذرا", text: models.arMsg, buttonText: "موافق")
                    })
                })
             }
         }){ [weak self] (error) in
            DispatchQueue.main.async(execute: { () -> Void in
                self!.saveChangeBtn.stopAnimation(animationStyle: .shake, completion: {
                    JSSAlertView().danger(self!, title: "عذرا", text: "تأكد من اتصالك بالانترنت", buttonText: "موافق")
                })
            })
        }
    }
    func remove_employee_info(id : String){
        NetworkClient.performRequest(status5Model.self, router: .remove_user(id: id), success: { [weak self] (models) in
           // self?.user_info = models
            print("models\( models)")
            if(models.status == 1){
                self?.navigationController?.popViewController(animated: true)
                JSSAlertView().success(self!,title: "حسنا",text: "تم الحذف بنجاح")
            }
            else if (models.status == 0 ){
                JSSAlertView().danger(self!, title: "عذرا", text: models.msg, buttonText: "موافق")
            }
            else if (models.status == 2 ){
                JSSAlertView().danger(self!, title: "عذرا", text: models.arMsg, buttonText: "موافق")
            }
        }){ [weak self] (error) in
                JSSAlertView().danger(self!, title: "عذرا", text: "تأكد من اتصالك بالانترنت", buttonText: "موافق")
            }
    }
}
//MARK: - Loader
extension addEmployeVC{
    func addAllViews(){
        self.errorView(mainNoDataView : &self.errorView, refreshBtn : &self.refreshErrorBtn)
        self.noInterNetView(mainNoDataView : &self.noInterNetView, refreshBtn :  &self.refreshInterNetBtn)
        self.noDataView(mainNoDataView: &self.noDataView, labelData: "لا توجد", refreshBtn: &self.refresDatahBtn, addStatus : 1, addFBtn : &addFBtn)
        self.showLoader(mainView: &loaderView)
        startAllAnimationBtn()
    }
    func hideAllViews(){
        self.hideLoader(mainView: &self.loaderView)
        self.hideNoDataView( mainNoDataView : &self.noDataView)
        self.hideNoInterNetView( mainNoInterNetView : &self.noInterNetView)
        self.hideErrorView( mainNoInterNetView : &self.errorView)
        stopAllAnimationBtn()
    }
    func stopAllAnimationBtn(){
        self.refresDatahBtn.stopAnimation(animationStyle: .shake, revertAfterDelay: 2, completion:nil)
        self.refreshErrorBtn.stopAnimation(animationStyle: .shake, revertAfterDelay: 2, completion:nil)
        self.refreshInterNetBtn.stopAnimation(animationStyle: .shake, revertAfterDelay: 2, completion:nil)
    }
    func startAllAnimationBtn(){
        refreshInterNetBtn.startAnimation()
        refresDatahBtn.startAnimation()
        refreshErrorBtn.startAnimation()
    }
}
