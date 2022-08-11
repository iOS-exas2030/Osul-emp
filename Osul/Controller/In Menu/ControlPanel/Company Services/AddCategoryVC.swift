//
//  AddCategoryVC.swift
//  AL-HHALIL
//
//  Created by Sayed Abdo on 12/3/20.
//  Copyright © 2020 Sayed Abdo. All rights reserved.
//

import UIKit
import JSSAlertView


class AddCategoryVC: UIViewController {
    
    @IBOutlet weak var companyNameTextField: UITextField!
    
    @IBOutlet weak var addNewView: UIView!
    @IBOutlet weak var addandDeleteView: UIView!
    //MARK: - Properties
    var addNew = true
    var CategoryName = ""
    var catId = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if(addNew == true){
            addandDeleteView.isHidden = true
        }else{
            addNewView.isHidden = true
            companyNameTextField.text = CategoryName
        }
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        self.getTokenReq()
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
           JSSAlertView().danger(self, title: "خطأ", text: "برجاء ادخال اسم التصنيف اولا ", buttonText: "موافق")
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
extension AddCategoryVC{
    func controllersAdd_comps(){
        NetworkClient.performRequest(CompanyOffersModel.self, router: .AddCategory(name: companyNameTextField.text ?? ""), success: { [weak self] (models) in
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
       NetworkClient.performRequest(CompanyOffersModel.self, router: .EditCategory(id: catId, name: companyNameTextField.text ?? ""), success: { [weak self] (models) in
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
        NetworkClient.performRequest(CompanyOffersModel.self, router: .RemoveCategory(id: catId), success: { [weak self] (models) in
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
