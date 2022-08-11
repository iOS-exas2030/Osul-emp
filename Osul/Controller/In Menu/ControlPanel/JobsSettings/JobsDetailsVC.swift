//
//  JobsDetailsVC.swift
//  AL-HHALIL
//
//  Created by apple on 8/7/20.
//  Copyright © 2020 Sayed Abdo. All rights reserved.
//

import UIKit
import JSSAlertView
import TransitionButton

class JobsDetailsVC: UIViewController ,UITextFieldDelegate{
    
    @IBOutlet weak var JobNameTF: UITextField!
    
    @IBOutlet weak var clientRequestEye: UIButton!
    @IBOutlet weak var contractEye: UIButton!
    @IBOutlet weak var projectsEye: UIButton!
    @IBOutlet weak var FinancialEye: UIButton!
    @IBOutlet weak var reportsEye: UIButton!
    @IBOutlet weak var controlPanelEye: UIButton!
    
    @IBOutlet weak var progressTimeEye: UIButton!
    
    @IBOutlet weak var headerTitle: UILabel!
    
    @IBOutlet weak var addView: UIView!
    @IBOutlet weak var editOrDeleteView: UIView!
    
    @IBOutlet weak var addBtn: TransitionButton!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var editBtn: UIButton!
    
    var clientRequest = ""
    var contract = ""
    var userGroup = UserGroupDatum(id: "", title: "", type: "", isClientOrder: "0", isContracting: "0", isProjects: "1", isReport: "0", isFinancial: "0", isSettings: "0",isProgressTime : "0")
    var id = ""
    var check = false
    var addNew = true
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        config()
    }
    func config(){
      //  get_users_groups_info(id: id)
        if(addNew == true){
            addView.isHidden = false
            editOrDeleteView.isHidden = true

        }else{
            addView.isHidden = true
            editOrDeleteView.isHidden = false
            headerTitle.text = "إعدادات الوظائف و الصلاحيات / تعديل"
            loadData()
        }
        addBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
        deleteBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
        editBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
        JobNameTF.delegate = self
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        self.getTokenReq()
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    @IBAction func saveAction(_ sender: UIButton) {
        if(JobNameTF.text == ""){
            JSSAlertView().danger(self, title: "خطأ", text: "برجاء ادخال اسم الموظيفه اولا ", buttonText: "موافق")
        }else{
            addBtn.startAnimation()
            let alertview = JSSAlertView().info(self,title: "تنبيه !",text: "هل تريد الحفظ ؟",
                            buttonText: "موافق",cancelButtonText: "إلغاء" )
            alertview.addAction {
                self.add_users_groups()
            }
            alertview.addCancelAction {
                print("cancel")
                self.addBtn.stopAnimation()
            }
        }
    }
    @IBAction func editAction(_ sender: UIButton) {
        if(JobNameTF.text == ""){
            JSSAlertView().danger(self, title: "خطأ", text: "برجاء ادخال اسم الموظيفه اولا ", buttonText: "موافق")
        }else{
            addBtn.startAnimation()
            let alertview = JSSAlertView().info(self,title: "تنبيه !",text: "هل تريد حفظ التعديلات؟",
                            buttonText: "موافق",cancelButtonText: "إلغاء" )
            alertview.addAction {
                self.edit_users_groups()
            }
            alertview.addCancelAction {
                print("cancel")
                self.addBtn.stopAnimation()
            }
        }
    }
    @IBAction func deleteAction(_ sender: UIButton) {
        let alertview = JSSAlertView().warning(self,title: "تنبيه !",text: "هل تريد الحذف ؟",
                        buttonText: "موافق",cancelButtonText: "إلغاء" )
        alertview.addAction {
            self.remove_users_groups_info(id : self.id)
        }
        alertview.addCancelAction {
            print("cancel")
        }
    }
}
// load edit data
extension JobsDetailsVC{
    func loadData(){
        JobNameTF.text = userGroup.title
        // isClientOrder
        if(userGroup.isClientOrder == "1"){
            clientRequestEye.tintColor = #colorLiteral(red: 0, green: 0.5603182912, blue: 0, alpha: 1)
        }
        else{
            clientRequestEye.tintColor = #colorLiteral(red: 0.3960784314, green: 0.1843137255, blue: 0.5568627451, alpha: 1)
        }
        // isContracting
        if(userGroup.isContracting == "1"){
            contractEye.tintColor = #colorLiteral(red: 0, green: 0.5603182912, blue: 0, alpha: 1)
        }
        else{
            contractEye.tintColor = #colorLiteral(red: 0.3960784314, green: 0.1843137255, blue: 0.5568627451, alpha: 1)
        }
        // isProjects
        if(userGroup.isProjects == "1"){
            projectsEye.tintColor = #colorLiteral(red: 0, green: 0.5603182912, blue: 0, alpha: 1)
        }
        else{
            projectsEye.tintColor = #colorLiteral(red: 0.3960784314, green: 0.1843137255, blue: 0.5568627451, alpha: 1)
        }
        // isFinancial
        if(userGroup.isFinancial == "1"){
            FinancialEye.tintColor = #colorLiteral(red: 0, green: 0.5603182912, blue: 0, alpha: 1)
        }
        else{
            FinancialEye.tintColor = #colorLiteral(red: 0.3960784314, green: 0.1843137255, blue: 0.5568627451, alpha: 1)
        }
        // isReport
        if(userGroup.isReport == "1"){
            reportsEye.tintColor = #colorLiteral(red: 0, green: 0.5603182912, blue: 0, alpha: 1)
        }
        else{
            reportsEye.tintColor = #colorLiteral(red: 0.3960784314, green: 0.1843137255, blue: 0.5568627451, alpha: 1)
        }
        // isSettings
        if(userGroup.isSettings == "1"){
            controlPanelEye.tintColor = #colorLiteral(red: 0, green: 0.5603182912, blue: 0, alpha: 1)
        }
        else{
            controlPanelEye.tintColor = #colorLiteral(red: 0.3960784314, green: 0.1843137255, blue: 0.5568627451, alpha: 1)
        }
        
        // isprogressTime
        if(userGroup.isProgressTime == "1"){
            progressTimeEye.tintColor = #colorLiteral(red: 0, green: 0.5603182912, blue: 0, alpha: 1)
        }
        else{
            progressTimeEye.tintColor = #colorLiteral(red: 0.3960784314, green: 0.1843137255, blue: 0.5568627451, alpha: 1)
        }
    }
}
// Eyes Actions arranged
extension JobsDetailsVC{
    @IBAction func clientRequestAction(_ sender: UIButton) {
        if(userGroup.isClientOrder == "0"){
            clientRequestEye.tintColor = #colorLiteral(red: 0, green: 0.5603182912, blue: 0, alpha: 1)
            userGroup.isClientOrder = "1"
        }
        else{
            clientRequestEye.tintColor = #colorLiteral(red: 0.3960784314, green: 0.1843137255, blue: 0.5568627451, alpha: 1)
            userGroup.isClientOrder = "0"
        }
    }
    @IBAction func contractEyeAction(_ sender: UIButton) {
        if(userGroup.isContracting == "0"){
            contractEye.tintColor = #colorLiteral(red: 0, green: 0.5603182912, blue: 0, alpha: 1)
            userGroup.isContracting = "1"
        }
        else{
            contractEye.tintColor = #colorLiteral(red: 0.3960784314, green: 0.1843137255, blue: 0.5568627451, alpha: 1)
            userGroup.isContracting = "0"
        }
    }
    @IBAction func projectsEyeAction(_ sender: UIButton) {
        if(userGroup.isProjects == "0"){
            projectsEye.tintColor = #colorLiteral(red: 0, green: 0.5603182912, blue: 0, alpha: 1)
            userGroup.isProjects = "1"
        }
        else{
            projectsEye.tintColor = #colorLiteral(red: 0.3960784314, green: 0.1843137255, blue: 0.5568627451, alpha: 1)
            userGroup.isProjects = "0"
        }
    }
    @IBAction func FinancialEyeAction(_ sender: UIButton) {
        if(userGroup.isFinancial == "0"){
            FinancialEye.tintColor = #colorLiteral(red: 0, green: 0.5603182912, blue: 0, alpha: 1)
            userGroup.isFinancial = "1"
        }
        else{
            FinancialEye.tintColor = #colorLiteral(red: 0.3960784314, green: 0.1843137255, blue: 0.5568627451, alpha: 1)
            userGroup.isFinancial = "0"
        }
    }
    @IBAction func reportsEyeAction(_ sender: UIButton) {
        if(userGroup.isReport == "0"){
            reportsEye.tintColor = #colorLiteral(red: 0, green: 0.5603182912, blue: 0, alpha: 1)
            userGroup.isReport = "1"
        }
        else{
            reportsEye.tintColor = #colorLiteral(red: 0.3960784314, green: 0.1843137255, blue: 0.5568627451, alpha: 1)
            userGroup.isReport = "0"
        }
    }
    @IBAction func controlPanelEyeAction(_ sender: UIButton) {
        if(userGroup.isSettings == "0"){
            controlPanelEye.tintColor = #colorLiteral(red: 0, green: 0.5603182912, blue: 0, alpha: 1)
            userGroup.isSettings = "1"
        }
        else{
            controlPanelEye.tintColor = #colorLiteral(red: 0.3960784314, green: 0.1843137255, blue: 0.5568627451, alpha: 1)
            userGroup.isSettings = "0"
        }
    }
    
    
    @IBAction func progressTimeEyeAction1(_ sender: UIButton) {
        if(userGroup.isProgressTime == "0"){
            progressTimeEye.tintColor = #colorLiteral(red: 0, green: 0.5603182912, blue: 0, alpha: 1)
            userGroup.isProgressTime = "1"
        }else{
            progressTimeEye.tintColor = #colorLiteral(red: 0.3960784314, green: 0.1843137255, blue: 0.5568627451, alpha: 1)
            userGroup.isProgressTime = "0"
        }
    }
}
// Request
extension JobsDetailsVC{
    func add_users_groups(){
        NetworkClient.performRequest(UserGroup.self, router: .add_users_group(title: JobNameTF.text!,is_client_order: userGroup.isClientOrder,is_contracting: userGroup.isContracting,is_projects: userGroup.isProjects,is_report: userGroup.isReport,is_financial: userGroup.isFinancial,is_settings: userGroup.isSettings, isProgressTime:  userGroup.isProgressTime),success: { [weak self] (models) in
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
                       JSSAlertView().danger(self!, title: "عذرا", text: "حدث حطأ ما حاول مره اخري", buttonText: "موافق")
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
    
    func edit_users_groups(){
        NetworkClient.performRequest(UserGroup.self, router: .edit_users_group(users_group_id: userGroup.id,title: JobNameTF.text!,is_client_order: userGroup.isClientOrder,is_contracting: userGroup.isContracting,is_projects: userGroup.isProjects,is_report: userGroup.isReport,is_financial: userGroup.isFinancial,is_settings: userGroup.isSettings, isProgressTime: userGroup.isProgressTime), success: { [weak self] (models) in
            if(models.status == 1){
                JSSAlertView().success(self!,title: "حسنا",text: "تم التعديل بنجاح")
               self?.navigationController?.popViewController(animated: true)
            }
            else if (models.status == 0 ){
                JSSAlertView().danger(self!, title: "عذرا", text: "حدث حطأ ما حاول مره اخري", buttonText: "موافق")
            }
        }){ [weak self] (error) in
                JSSAlertView().danger(self!, title: "عذرا", text: "تأكد من اتصالك بالانترنت", buttonText: "موافق")
          }
    }
    func remove_users_groups_info(id : String){
        NetworkClient.performRequest(UserGroup.self, router: .remove_users_group(id: id), success: { [weak self] (models) in
          if(models.status == 1){
            JSSAlertView().success(self!,title: "حسنا",text: "تم الحذف بنجاح")
            self?.navigationController?.popViewController(animated: true)
           
          }else if (models.status == 0 ){
            JSSAlertView().danger(self!, title: "عذرا", text: models.arMsg, buttonText: "موافق")
          }
       }){ [weak self] (error) in
            JSSAlertView().danger(self!, title: "عذرا", text: "تأكد من اتصالك بالانترنت", buttonText: "موافق")
         }
    }
}
//MARK: - UITextFieldDelegate
extension JobsDetailsVC{
    //
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if(textField == JobNameTF){
            JobNameTF.layer.borderColor = #colorLiteral(red: 0.4763007164, green: 0.2721414864, blue: 0.625670135, alpha: 0.8470588235) //your color
            JobNameTF.layer.borderWidth = 1.0
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if(textField == JobNameTF){
            JobNameTF.layer.borderWidth = 0.0
        }
    }
    //
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
