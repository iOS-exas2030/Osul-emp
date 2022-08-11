//
//  StartProjectVC.swift
//  AL-HHALIL
//
//  Created by Sayed Abdo on 10/16/20.
//  Copyright © 2020 Sayed Abdo. All rights reserved.
//

import UIKit
import JSSAlertView
import TransitionButton

protocol StarProjectDelegate {
     func reload()
}
class StartProjectVC: UIViewController {
    
    @IBOutlet weak var dateFromTextField: UITextField!
    @IBOutlet weak var checkView: UIView!
    let  fromDatePicker = UIDatePicker()
    var projectId = ""
    var confirmedStatus = ""
    var confirmedDate = ""
    var delegate: StarProjectDelegate?
  //  var projectId = ""
    @IBOutlet weak var checkButton: UIButton!
    var isChecked = false
    @IBOutlet weak var startBtn: TransitionButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.showFromDatePicker()
        let tap2: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(check))
        checkButton.addGestureRecognizer(tap2)
        if(confirmedStatus == "1"){
            dateFromTextField.isEnabled = false
            dateFromTextField.text = confirmedDate
            startBtn.isEnabled = false
            checkButton.isHidden = false
            checkButton.isEnabled = false
        }else{
            checkButton.isHidden = true
            dateFromTextField.isEnabled = true
            startBtn.isEnabled = true
        }
        let tap3: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(check))
        checkView.addGestureRecognizer(tap3)
    }
    override func viewWillAppear(_ animated: Bool) {
        getTokenReq()
    }
    
    @objc func check (){
        if(confirmedStatus == "1"){
            
        }else{
           if(isChecked){
               checkButton.isHidden = true
               isChecked = false
           }else{
               checkButton.isHidden = false
               isChecked = true
           }
        }
   }
    @IBAction func startAction(_ sender: Any) {
        startBtn.startAnimation()
        if(dateFromTextField.text == ""){
            startBtn.stopAnimation()
            JSSAlertView().danger(self, title: "عذرا", text: "برجاء تحديد تاريخ التفعيل اولا", buttonText: "موافق")
        }else if( isChecked == false){
            startBtn.stopAnimation()
            JSSAlertView().danger(self, title: "عذرا", text: "برجاء تحديد الموافقه اولا", buttonText: "موافق")
        }else{
            confirmStartProjectReq()
        }
    }
    @IBAction func closeConfirmed(_ sender: Any) {
        dismiss(animated: true)
    }
}

//Picker
extension StartProjectVC{
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
//Request
extension StartProjectVC{
    func confirmStartProjectReq(){
        let userId = UserDefaults.standard.value(forKey: "userId") as? String
        NetworkClient.performRequest(Contracts.self, router: .confirmStartProject(project_id: projectId, emp_id: userId ?? "", confirm_date: dateFromTextField.text ?? ""), success: { [weak self] (models) in
                if(models.status == 1){
                    if let delegate = self?.delegate {
                        delegate.reload()
                     }
                    let alertview = JSSAlertView().success(self!,title : "حسنا",text: "تم التفعيل بنجاح", buttonText: "موافق")
                    alertview.addAction {
                        self!.dismiss(animated: true)
//                        let view = self?.storyboard?.instantiateViewController(identifier: "ContractDetailsVC") as! ContractDetailsVC
//                        view.projectId = self!.projectId
//                        //view.progress = contractArr[indexPath.row].projectProgress
//                        self?.navigationController?.pushViewController(view, animated: true)
                        //self?.viewWillAppear(true)
                    }
                }
                else if (models.status == 0 ){
                    self?.startBtn.stopAnimation()
               }
           }){ [weak self] (error) in
                    self?.startBtn.stopAnimation()
            }
    }
}
