//
//  AddCompanyServicesVC.swift
//  AL-HHALIL
//
//  Created by Sayed Abdo on 8/23/20.
//  Copyright © 2020 Sayed Abdo. All rights reserved.
//

import UIKit
import JSSAlertView
class AddCompanyServicesVC: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var compantDgreeTextField: UITextField!
    @IBOutlet weak var companyNameTextField: UITextField!
    
    @IBOutlet weak var addNewView: UIView!
    @IBOutlet weak var addandDeleteView: UIView!
    //MARK: - Properties
    var addNew = true
    var companyName = ""
    var companydis_degree = ""
    var id = ""
    var catId = ""

    //MARK: - View Controller Builder
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if(addNew == true){
            addandDeleteView.isHidden = true
        }else{
            addNewView.isHidden = true
            compantDgreeTextField.text = companydis_degree
            companyNameTextField.text = companyName
        }
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.getTokenReq()
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    @IBAction func deleteAction(_ sender: UIButton) {
        controllersRemove_comps()
    }
    @IBAction func saveAction(_ sender: UIButton) {
        validation()
    }
    @IBAction func addNewAction(_ sender: UIButton) {
       validation()
    }
    func validation(){
        if(companyNameTextField.text == ""){
            JSSAlertView().danger(self, title: "خطأ", text: "برجاء ادخال اسم الشركة ", buttonText: "موافق")
        }else if(compantDgreeTextField.text == ""){
            JSSAlertView().danger(self, title: "خطأ", text: "برجاء ادخال نسبة الخصم  ", buttonText: "موافق")
        }else{
            if(addNew == true){
              controllersAdd_comps()
            }else{
              controllersEdit_comps()
            }
        }
    }
}
// Request
extension AddCompanyServicesVC{
    func controllersAdd_comps(){
        NetworkClient.performRequest(CompanyOffersModel.self, router: .controllersAdd_comps(com_name: companyNameTextField.text ?? "", percent: compantDgreeTextField.text ?? "", cat_id: catId), success: { [weak self] (models) in
             print("models\( models.data)")
             if(models.status == 1){
                JSSAlertView().success(self!,title: "حسنا",text: "تم الحفظ بنجاح")
                self?.navigationController?.popViewController(animated: true)
             }
             else if (models.status == 0 ){
             }
         }){ [weak self] (error) in
         }
    }
    func controllersEdit_comps(){
        NetworkClient.performRequest(CompanyOffersModel.self, router: .controllersEdit_comps(sale_id: id, com_name: companyNameTextField.text ?? "", percent: compantDgreeTextField.text ?? ""), success: { [weak self] (models) in
             print("models\( models.data)")
             if(models.status == 1){
                self?.navigationController?.popViewController(animated: true)
                JSSAlertView().success(self!,title: "حسنا",text: "تم التعديل بنجاح")
             }
             else if (models.status == 0 ){
             }
         }){ [weak self] (error) in
         }
     }
    func controllersRemove_comps(){
        NetworkClient.performRequest(CompanyOffersModel.self, router: .controllersRemove_comps(sale_id: id), success: { [weak self] (models) in
                print("models\( models.data)")
                if(models.status == 1){
                   self?.navigationController?.popViewController(animated: true)
                   JSSAlertView().success(self!,title: "حسنا",text: "تم الحذف بنجاح")
                }
                else if (models.status == 0 ){
                }
            }){ [weak self] (error) in
            }
    }
}
