//
//  AddExplanationVC.swift
//  AL-HHALIL
//
//  Created by Sayed Abdo on 8/13/20.
//  Copyright © 2020 Sayed Abdo. All rights reserved.
//

import UIKit
import TransitionButton
import JSSAlertView

class AddExplanationVC: UIViewController , UITextViewDelegate , UITextFieldDelegate {

    
    //MARK: - IBOutlets
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var timeTextField: UITextField!
    @IBOutlet weak var employeeNameTextField: UITextField!
    @IBOutlet weak var addExplanationBtn: TransitionButton!

    //MARK: - Properties
    let date = Date()
    let formatter = DateFormatter()
    let formatter1 = DateFormatter()
    var addNew : Bool = true
    var fromAll : Bool!
    var currentExplanation : ExplanationModelDatum!
    var ExplanationContract: ExplanationModelDatum!
    var projectId : String!
    let defaults = UserDefaults.standard
    var moving : Int!
    var myNewView = UIView()

    //MARK: - View Controller Builder
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        config()
    }
    func config(){
        showLoader(mainView: &myNewView)
        textView.delegate = self
        textView.text = "التفاصيل ٫٫٫"
        textView.textColor = UIColor.lightGray
        addExplanationBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
        formatter.dateFormat = "yyyy-MM-dd"
        formatter1.dateFormat = "HH:mm:ss"
        let result = formatter.string(from: date)
        let result1 = formatter1.string(from: date)
        dateTextField.text = result
        timeTextField.text = result1
        employeeNameTextField.text =  defaults.value(forKeyPath: "userName")! as? String
        if(addNew == false && fromAll == false){
            titleTextField.text = currentExplanation.title
            dateTextField.text = currentExplanation.date
            timeTextField.text = currentExplanation.time
            employeeNameTextField.text = currentExplanation.empName
            textView.text = currentExplanation.comments
            titleTextField.isEnabled = false
            textView.isUserInteractionEnabled = false
            addExplanationBtn.isHidden = true
        }
        if(addNew == false && fromAll == true){
            titleTextField.text = ExplanationContract.title
            dateTextField.text = ExplanationContract.date
            timeTextField.text = ExplanationContract.time
            employeeNameTextField.text = ExplanationContract.empName
            textView.text = ExplanationContract.comments
            titleTextField.isEnabled = false
            textView.isUserInteractionEnabled = false
            addExplanationBtn.isHidden = true
        }
        self.hideLoader(mainView: &self.myNewView)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        titleTextField.delegate = self
        getTokenReq()
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
          self.view.endEditing(true)
          return true
    }
    func successAdd(){
        if(fromAll == true && addNew == true){
            let view = self.storyboard?.instantiateViewController(withIdentifier: "ExplanationsVC") as! ExplanationsVC
            view.projectId = self.projectId
            self.navigationController?.popViewController(animated: true)
        }else if(fromAll == true && addNew == false){
            let view = self.storyboard?.instantiateViewController(withIdentifier: "ExplanationsVC") as! ExplanationsVC
            view.projectId = self.projectId
            self.navigationController?.popViewController(animated: true)
        }else{
            let view = self.storyboard?.instantiateViewController(withIdentifier: "NewOrderdetailsVC") as! NewOrderdetailsVC
            view.projectId = self.projectId
            self.navigationController?.popViewController(animated: true)
            //self.navigationController?.pushViewController(view, animated: true)
        }
    }
    @IBAction func addExplanationAction(_ sender: Any) {
        if(titleTextField.text == ""){
            JSSAlertView().danger(self, title: "خطأ", text: "برجاء ادخال عنوان الشرح", buttonText: "موافق")
        }else if(textView.text == "التفاصيل ٫٫٫"){
            JSSAlertView().danger(self, title: "خطأ", text: "برجاء ادخال تفاصيل الشرح ", buttonText: "موافق")
        }else{
            addExplanation()
        }
    }
}
//MARK: - UITextView Delegate
extension AddExplanationVC{
    func textViewDidBeginEditing(_ textView: UITextView) {
         if(addNew == true){
            if textView.textColor == UIColor.lightGray {
                textView.text = nil
                textView.textColor = UIColor.black
            }
        }
    }
}
//MARK: - Request
extension AddExplanationVC{
    func addExplanation(){
        addExplanationBtn.startAnimation()
        NetworkClient.performRequest(statusModel.self, router: .addExplanation(title: titleTextField.text!, comments: textView.text!, date: dateTextField.text!, time: timeTextField.text!, emp_id: (defaults.value(forKeyPath: "userId")! as? String)!, project_id: projectId), success: { [weak self] (models) in
            if(models.status == 1){
                DispatchQueue.main.async(execute: { () -> Void in
                  self!.addExplanationBtn.stopAnimation(animationStyle: .normal, completion: {
                    let alertview = JSSAlertView().success(self!,title: "حسنا",text: "تم الحفظ بنجاح", buttonText: "موافق")
                    alertview.addAction(self!.successAdd)
                  })
                })
            }
            else if (models.status == 0 ){
                DispatchQueue.main.async(execute: { () -> Void in
                    self!.addExplanationBtn.stopAnimation(animationStyle: .shake, completion: {
                        JSSAlertView().danger(self!, title: "عذرا", text: "حدث حطأ ما حاول مره اخري", buttonText: "موافق")
                    })
                })
            }
        }){ [weak self] (error) in
                DispatchQueue.main.async(execute: { () -> Void in
                    self!.addExplanationBtn.stopAnimation(animationStyle: .shake, completion: {
                        JSSAlertView().danger(self!, title: "عذرا", text: "تأكد من اتصالك بالانترنت", buttonText: "موافق")
                    })
                })
        }
    }
}
