//
//  InternalDetailsVC.swift
//  AL-HHALIL
//
//  Created by Sayed Abdo on 7/23/20.
//  Copyright © 2020 Sayed Abdo. All rights reserved.
//

import UIKit
import JSSAlertView
protocol internalBackAction{
    func add(array : Level_DetailsDatum, controller: InternalDetailsVC)
}

class InternalDetailsVC: UIViewController {
    
//MARK: - IBOutlets
    @IBOutlet weak var isPdfView: UIView!
    @IBOutlet weak var isPdfButton: UIButton!
    @IBOutlet weak var percentageTF: UITextField!
    @IBOutlet weak var subjectNameTF: UITextField!

//MARK: - Properties
    var internalbackDelegate : internalBackAction?
    var all_level_details : Level_Details!
    var getDetails : GetDetailsLevel?
    var id = ""
    var levelid = ""
    var levelType = ""
    var ispdf = ""
    var addNew = true
    var myNewView = UIView()
//MARK: - View Controller Builder
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.getTokenReq()
    }
    func config(){
        showLoader(mainView: &myNewView)
        isPdfButton.isHidden = true
        let checkBoxTap = UITapGestureRecognizer(target: self, action: #selector(checkBoxAction))
        isPdfView.addGestureRecognizer(checkBoxTap)
        if addNew == true{
            isPdfButton.isHidden = true
            self.hideLoader(mainView: &self.myNewView)
        }else {
           get_level_details_info(id: id)
        }
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    //isPDF checkBox Action 
    @objc func checkBoxAction(){
        if isPdfButton.isHidden == true {
            isPdfButton.isHidden = false
            ispdf = "1"
        }else{
            isPdfButton.isHidden = true
            ispdf = "0"
        }
    }
    @IBAction func saveButton(_ sender: UIButton) {
       validation()
    }
    func validation(){
            if(subjectNameTF.text == ""){
                JSSAlertView().danger(self, title: "خطأ", text: "برجاء ادخال اسم الموضوع ", buttonText: "موافق")
            }else if(percentageTF.text == ""){
                JSSAlertView().danger(self, title: "خطأ", text: "برجاء ادخال نسبة الانجاز من المرحلة ", buttonText: "موافق")
            }else if(addNew == true){
                  add_level_details()
            }else{
                  edit_level_details()
            }
   }
}
//MARK: - Request
extension InternalDetailsVC {

    func get_level_details_info(id : String){
     NetworkClient.performRequest(GetDetailsLevel.self, router: .get_level_details_info(id: id), success: { [weak self] (models) in
        self?.getDetails = models
         print("models\( models)")
         if(models.status == 1){
            self?.subjectNameTF.text = self?.getDetails?.data?.title
            self?.percentageTF.text = self?.getDetails?.data?.percent
            if self?.getDetails?.data?.isPDF == "1" {
                self?.ispdf = "1"
                self?.isPdfButton.isHidden = false
            }else if self?.getDetails?.data?.isPDF == "0" {
                self?.ispdf = "0"
                self?.isPdfButton.isHidden = true
            }
            self!.hideLoader(mainView: &self!.myNewView)
         }
         else if (models.status == 0 ){
            JSSAlertView().danger(self!, title: "عذرا", text: "حدث حطأ ما حاول مره اخري", buttonText: "موافق")
         }
     }){ [weak self] (error) in
        JSSAlertView().danger(self!, title: "عذرا", text: "تأكد من اتصالك بالانترنت", buttonText: "موافق")
     }
    }
    func add_level_details(){
        NetworkClient.performRequest(Level_Details.self, router: .add_level_details(title: subjectNameTF.text!, level_id: levelid, percent: percentageTF.text!, is_pdf: ispdf, type: levelType, values: [""], question_type: ""), success: { [weak self] (models) in
            self?.all_level_details = models
            print("models\( models)")
            if(models.status == 1){
               self?.internalbackDelegate?.add(array: models.data[0], controller: self!)
               self?.navigationController?.popViewController(animated: true)
               JSSAlertView().success(self!,title: "حسنا",text: "تم الحفظ بنجاح")
            }
            else if (models.status == 0 ){
                JSSAlertView().danger(self!, title: "عذرا", text: models.arMsg, buttonText: "موافق")
            }
        }){ [weak self] (error) in
//            JSSAlertView().danger(self!, title: "عذرا", text: self?.all_level_details.arMsg, buttonText: "موافق")
        }
    }
    func edit_level_details(){
        NetworkClient.performRequest(Level_Details.self, router: .edit_level_details(level_details_id: id, title:  subjectNameTF.text! , level_id: levelid, percent:percentageTF.text!, is_pdf: ispdf, type: levelType, values: [""], question_type: ""), success: { [weak self] (models) in
            self?.all_level_details = models
            print("models\( models)")
            if(models.status == 1){
                self?.internalbackDelegate?.add(array: models.data[0], controller: self!)
                self?.navigationController?.popViewController(animated: true)
                JSSAlertView().success(self!,title: "حسنا",text: "تم الحفظ بنجاح")
            }
            else if (models.status == 0 ){
                JSSAlertView().danger(self!, title: "عذرا", text: models.arMsg, buttonText: "موافق")
            }
        }){ [weak self] (error) in
            JSSAlertView().danger(self!, title: "عذرا", text:"تأكد من اتصالك بالانترنت", buttonText: "موافق")
        }
    }
}
