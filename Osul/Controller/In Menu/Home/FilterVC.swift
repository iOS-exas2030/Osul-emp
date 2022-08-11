//
//  filterVC.swift
//  AL-HHALIL
//
//  Created by Sayed Abdo on 10/14/20.
//  Copyright © 2020 Sayed Abdo. All rights reserved.
//

import UIKit
import SwiftRangeSlider
import JSSAlertView

protocol ModalDelegate {
func changeValue(value: Int)
}
class FilterVC: UIViewController {
    
    @IBOutlet weak var contractTypeDropDown: DropDown!
    @IBOutlet weak var projectTypeDropDown: DropDown!
    @IBOutlet weak var rangeSlider: RangeSlider!
    
    @IBOutlet weak var toTF: UITextField!
    @IBOutlet weak var fromTF: UITextField!
   // @IBOutlet weak var dateFromTextField: UITextField!
   // @IBOutlet weak var toFromTextField: UITextField!
    let  toDatePicker = UIDatePicker()
    let  fromDatePicker = UIDatePicker()
    var delegate: ModalDelegate?
    var AllContractArray = [ContractsDatum]()
    var contractArray = [String]()
    var selectedContractId :String? = ""
    
    var AllProjectTypeArray = [ContractsDatum]()
    var projectTypeArray = [String]()
    var selectedProjectType : String? = ""
    var projectData = [ProjectModelDatum]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        get_all_contracts()
        projectTypeReq()
        self.showToDatePicker()
        self.showFromDatePicker()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        self.contractTypeDropDown.didSelect { (selectedText , index ,id) in
            self.selectedContractId = self.AllContractArray[index].id
        }
        
        self.projectTypeDropDown.didSelect { (selectedText , index ,id) in
            self.selectedProjectType = self.projectTypeArray[index]
        }
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    @IBAction func closeFilter(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func searchAction(_ sender: Any) {
        searchReq()
    }
    
}
extension FilterVC{
    func get_all_contracts(){
           NetworkClient.performRequest(Contracts.self, router: .get_all_contracts, success: { [weak self] (models) in
                if(models.status == 1){
                    for contractCounter in models.data {
                          self?.contractArray.append(contractCounter.title)
                    }
                    self?.AllContractArray = models.data
                    self?.contractTypeDropDown.optionArray = self?.contractArray ?? [""]
                    self?.contractTypeDropDown.rowHeight = 50
                }
                else if (models.status == 0 ){
                    
               }
           }){ [weak self] (error) in
                   
            }
    }
    
    func projectTypeReq(){
           NetworkClient.performRequest(ProjectTypeModel.self, router: .projectType, success: { [weak self] (models) in
                if(models.status == 1){
                    for projectTypeCounter in models.data! {
                        self?.projectTypeArray.append(projectTypeCounter.title ?? "")
                    }
                    self?.projectTypeDropDown.optionArray = self?.projectTypeArray ?? [""]
                    self?.projectTypeDropDown.rowHeight = 50
                    
                }
                else if (models.status == 0 ){
               }
           }){ [weak self] (error) in
            }
    }
    func searchReq(){
        NetworkClient.performRequest(ProjectModel.self, router: .ProjectsSearch(project_type: (selectedProjectType ?? "")!, contractType: (selectedContractId ?? "")!, to: fromTF.text!, from: toTF.text!, progressTo: Int(rangeSlider?.upperValue ?? 0.0), progressFrom: Int(rangeSlider?.lowerValue ?? 100.0), state: ""), success: { [weak self] (models) in
            print("to \(self?.toTF.text!)")
            print("from \(self?.fromTF.text!)")
                if(models.status == 1){
                 //    self?.dismiss(animated: true)
                    print("wwwwwwwww\(models)")
                    let view = self?.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                    view.fromSearch = 1
                    view.projectData = models.data!
                   // view.projectCollectionView.reloadData()
               //     if let delegate = self?.delegate {
               //         delegate.changeValue(value: 1)
              //      }
                  //  self?.dismiss(animated: true)
                   // self?.navigationController?.popViewController(animated: true)
                    self?.navigationController?.pushViewController(view, animated: true)
                }
                else if (models.status == 2 ){
                    print("2")
                   
                    let alertview =  JSSAlertView().danger(self!, title: "عذرا", text: models.arMsg, buttonText: "موافق")
                    alertview.addAction {
                        self?.dismiss(animated: true)
                    }
                  //   self?.dismiss(animated: true)
//                    let view = self?.storyboard?.instantiateViewController(identifier: "HomeVC") as! HomeVC
//                    view.fromSearch = 2
//                    self?.navigationController?.popViewController(animated: true)
                    if let delegate = self?.delegate {
                        delegate.changeValue(value: 2)
                     }
                   
               }
           }){ [weak self] (error) in
           //  self?.dismiss(animated: true)
            print("3")
            if let delegate = self?.delegate {
                delegate.changeValue(value: 2)
              }
            self?.dismiss(animated: true)
            }
    }
}

//Picker
extension FilterVC{
    func showToDatePicker(){
        //Formate Date
        toDatePicker.datePickerMode = .date
        //ToolBar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        toolbar.tintColor = UIColor.black
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        toTF.inputAccessoryView = toolbar
        toTF.inputView = toDatePicker
    }
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
        fromTF.inputAccessoryView = toolbar
        fromTF.inputView = fromDatePicker
    }
    @objc func donedatePicker(){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        toTF.text = formatter.string(from: toDatePicker.date)
        self.view.endEditing(true)
    }
    @objc func donetimePicker(){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        fromTF.text = formatter.string(from: fromDatePicker.date)
        self.view.endEditing(true)
    }
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
}
