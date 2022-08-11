//
//  AddProjectVC.swift
//  AL-HHALIL
//
//  Created by Sayed Abdo on 3/11/21.
//  Copyright © 2021 Sayed Abdo. All rights reserved.
//

import UIKit
import JSSAlertView

class AddProjectVC: UIViewController {
    
    @IBOutlet weak var projectNameTextField: UITextField!
    
    @IBOutlet weak var linkTF: UITextField!
    @IBOutlet weak var setLocationView: UIView!
    @IBOutlet weak var linkView: UIView!
    
    @IBOutlet weak var clientDropDown: DropDown!
    var clientDone = false
    var selectedClient : String!
    var AllClientArray = [ClientModelDatum]()
    var clientArray = [String]()
    
    @IBOutlet weak var contractTypeDropDown: DropDown!
    var contractDone = false
    var selectedContract : String!
    var AllContractArray = [ContractsDatum]()
    var contractArray = [String]()
    
    
    @IBOutlet weak var statesView: UIView!
    @IBOutlet weak var stateDropDown: DropDown!
    var AllstateArray = [StatesDatum]()
    var stateArray = [String]()
    var selectedState : String?
    var StateDone = false
    

    
    @IBOutlet weak var counteryDropDown: DropDown!
    var counteryArray = ["داخل المملكة العربية السعودية","خارج الممكلة العربية السعودية"]
    var selectedCountery : String?
    var counteryDone = false
    
    
     @IBOutlet weak var locationType: DropDown!
    var locationTypeArray = ["اضافة رابط الموقع","تحديد الموقع"]
    var selectedlocationType: String? = "0"
    var locationTypeDone = false

    
    @IBOutlet weak var projectTypeDropDown: DropDown!
    var projectTypeArray = ["فيلا سكنية","شاليه","عمارة سكنية","مدرسة","مكتب","مطعم","فندق","مسجد","شركة","أخرى"]
    var selectedprojectType : String?
    var projectTypeDone = false
    
    @IBOutlet weak var dateFromTextField: UITextField!
    
    let  fromDatePicker = UIDatePicker()
    var selectedLong :Double = 0.0
    var selectedLat :Double = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        clientDropDown.listHeight = 400
        self.clientDropDown.didSelect { (selectedText , index ,id) in
            self.selectedClient = self.AllClientArray[index].id
            self.clientDone = true
        }
        
        self.contractTypeDropDown.didSelect { (selectedText , index ,id) in
            self.selectedContract = self.AllContractArray[index].id
            self.contractDone = true
        }
        self.stateDropDown.didSelect{(selectedText , index ,id) in
            self.selectedState = self.AllstateArray[index].id
            self.StateDone = true
        }
        self.locationType.didSelect{(selectedText , index ,id) in
            self.locationTypeDone = true
            if index == 0{
                self.linkView.isHidden = false
                self.setLocationView.isHidden = true
                self.selectedlocationType = "0"
                self.locationTypeDone = true
            }else if index == 1{
                self.setLocationView.isHidden = false
                self.linkView.isHidden = true
                 self.selectedlocationType = "1"
                self.locationTypeDone = true
            }
        }
        locationType.optionArray = locationTypeArray
        locationType.rowHeight = 50
        
        self.counteryDropDown.didSelect{(selectedText , index ,id) in
            self.selectedCountery = self.counteryArray[index]
            self.counteryDone = true
            if(index == 0){
                self.statesView.isHidden = false
            }else{
                self.statesView.isHidden = true
                self.StateDone = false
                self.stateDropDown.text = ""
                self.stateDropDown.isSelected = false
                self.selectedState = ""
            }
        }
        counteryDropDown.optionArray = counteryArray
        counteryDropDown.rowHeight = 70
        
        self.projectTypeDropDown.didSelect{(selectedText , index ,id) in
            self.selectedprojectType = self.projectTypeArray[index]
            self.projectTypeDone = true
        }
        projectTypeDropDown.optionArray = projectTypeArray
        projectTypeDropDown.rowHeight = 50
        
        self.showFromDatePicker()
        
        get_all_contracts()
        get_all_status()
        getALLClientsReq()
    }
    
    
    @IBAction func openMap(_ sender: Any) {
        let view = self.storyboard?.instantiateViewController(withIdentifier: "mapVC") as! mapVC
        view.longitude =  "\(selectedLong)"
        view.latitude = "\(selectedLat)"
        view.projectName = projectNameTextField.text ?? ""
        view.delegete = self as ReturnLocationDelegate
        self.navigationController?.pushViewController(view, animated: true)
        
    }
    @IBAction func saveAction(_ sender: Any) {
        if(projectNameTextField.text == ""){
            JSSAlertView().danger(self, title: "عذرا", text: "برجاء إدخال إسم المشروع", buttonText: "موافق")
        }else if(clientDone == false){
            JSSAlertView().danger(self, title: "عذرا", text: "برجاء تحديد العميل", buttonText: "موافق")
        }else if(contractDone == false){
            JSSAlertView().danger(self, title: "عذرا", text: "برجاء تحديد نوع العقد", buttonText: "موافق")
        }else if(dateFromTextField.text == ""){
            JSSAlertView().danger(self, title: "عذرا", text: "برجاء تحديد تاريخ التفعيل", buttonText: "موافق")
        }else if(projectTypeDone == false){
            JSSAlertView().danger(self, title: "عذرا", text: "برجاء تحديد نوع المشروع", buttonText: "موافق")
        }else if(counteryDone == false){
            JSSAlertView().danger(self, title: "عذرا", text: "برجاء تحديد البلد", buttonText: "موافق")
        }else if(counteryDone == true && StateDone == false && selectedCountery == "داخل المملكة العربية السعودية"){
            JSSAlertView().danger(self, title: "عذرا", text: "برجاء تحديد المدينه", buttonText: "موافق")
        }
//        else if(locationTypeDone == false){
//            JSSAlertView().danger(self, title: "عذرا", text: "برجاء اختيار طريقة تحديد الموقع", buttonText: "موافق")
//        }
//        else if(locationTypeDone == true && selectedlocationType == "0" && linkTF.text == ""){
//            JSSAlertView().danger(self, title: "عذرا", text: "برجاء اضافة رابط الموقع", buttonText: "موافق")
//        }
//        else if (locationTypeDone == true  && selectedlocationType == "1" && selectedLat == 0.0 && selectedLong == 0.0){
//            JSSAlertView().danger(self, title: "عذرا", text: "برجاء تحديد الموقع", buttonText: "موافق")
//        }
        else{
            print("Done")
            addProject()
        }
    }

}
extension AddProjectVC : ReturnLocationDelegate {
    func locationBack(lat: Double, long: Double) {
        self.selectedLat = lat
        self.selectedLong = long
    }
}
//Picker
extension AddProjectVC{
    func showFromDatePicker(){
        //Formate Date
        fromDatePicker.datePickerMode = .date
        //ToolBar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        toolbar.tintColor = UIColor.black
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donetimePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        dateFromTextField.inputAccessoryView = toolbar
        dateFromTextField.inputView = fromDatePicker
    }
    @objc func donetimePicker(){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        dateFromTextField.text = formatter.string(from: fromDatePicker.date)
        self.view.endEditing(true)
    }
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
}
//MARK: - Request
extension AddProjectVC{
    func get_all_contracts(){
           NetworkClient.performRequest(Contracts.self, router: .get_all_contracts, success: { [weak self] (models) in
                if(models.status == 1){
                    self?.AllContractArray = models.data
                    for contractCounter in models.data {
                        self?.contractArray.append(contractCounter.title)
                    }
                    self?.contractTypeDropDown.optionArray = self?.contractArray ?? [""]
                    self?.contractTypeDropDown.rowHeight = 50
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
                if(models.status == 1){
                    self?.AllstateArray = models.data
                    for statesCounter in models.data {
                        self?.stateArray.append(statesCounter.title)
                    }
                    self?.stateDropDown.optionArray = self?.stateArray ?? [""]
                    self?.stateDropDown.rowHeight = 50
                }
                else if (models.status == 0 ){
                    JSSAlertView().danger(self!, title: "عذرا", text: "حدث حطأ ما حاول مره اخري", buttonText: "موافق")
                }
        }){ [weak self] (error) in
                JSSAlertView().danger(self!, title: "عذرا", text: "تأكد من اتصالك بالانترنت", buttonText: "موافق")
            }
    }
    func getALLClientsReq(){
        NetworkClient.performRequest(ClientModel.self, router: .getALLClients, success: { [weak self] (models) in
                if(models.status == 1){
                    self?.AllClientArray = models.data ?? []
                    for statesCounter in models.data! {
                        self?.clientArray.append(statesCounter.name ?? "")
                    }
                    self?.clientDropDown.optionArray = self?.clientArray ?? [""]
                    self?.clientDropDown.rowHeight = 50
                    print("self?.clientArray : \(self?.clientArray.count)")
                }
                else if (models.status == 0 ){
                    JSSAlertView().danger(self!, title: "عذرا", text: "حدث حطأ ما حاول مره اخري", buttonText: "موافق")
                }
        }){ [weak self] (error) in
                JSSAlertView().danger(self!, title: "عذرا", text: "تأكد من اتصالك بالانترنت", buttonText: "موافق")
            }
    }
}

//MARK: - Request
extension AddProjectVC{
    
    func addProject(){
        
        var latString = ""
        var longString = ""
        
        if(selectedLat == 0.0 || selectedLong == 0.0){
             latString = ""
             longString = ""
        }else{
            latString = String(selectedLat)
            longString = String(selectedLong)
        }
        
        
        let userId =  (UserDefaults.standard.value(forKey: "userId") as? String)!
        NetworkClient.performRequest(DeleteChatMessegeModel.self, router: .createProject(client_id: selectedClient, projectName: projectNameTextField.text!, country: selectedCountery!, state: selectedState!, project_type: selectedprojectType!, area: "", confirm_date: dateFromTextField.text!, contract_id: selectedContract, created_by: userId, lat: latString, lng: latString, addressType: selectedlocationType!, adressLink: linkTF.text ?? "" ), success: { [weak self] (models) in
           //  self?.assign = models
            print("models\( models.data)")
             if(models.status == 1){
                JSSAlertView().success(self!,title : "حسنا",text: "تم الحفظ بنجاح", buttonText: "موافق")
                self?.navigationController?.popViewController(animated: true)
             }
             else if (models.status == 0 ){
                 JSSAlertView().danger(self!, title: "عذرا", text: "حدث حطأ ما حاول مره اخري", buttonText: "موافق")
                print(" error \(models.msg)")
             }
         }){ [weak self] (error) in
            
         }
     }
    

}
