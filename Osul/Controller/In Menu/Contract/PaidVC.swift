//
//  PaidVC.swift
//  AL-HHALIL
//
//  Created by apple on 10/10/20.
//  Copyright © 2020 Sayed Abdo. All rights reserved.
//

import UIKit
import JSSAlertView
import TransitionButton

class PaidVC: UIViewController, UITextViewDelegate , UITextFieldDelegate {

    @IBOutlet weak var totalPaidTF: UITextField!
    @IBOutlet weak var notPaidyetTF: UITextField!
    @IBOutlet weak var paidTF: UITextField!
    var projectID = ""
    var paisData = ["","",""]
    var confirmedStatus = ""
    
    var num1 = 0.0
    var num2 = 0.0
    
    
    @IBOutlet weak var saveBtn: TransitionButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        paidTF.delegate = self
        paidTF.addTarget(self, action: #selector(self.textFieldDidChange(sender:)), for: .editingChanged)
        openPaidProjectReq()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        if(confirmedStatus == "1"){
            totalPaidTF.isEnabled = false
            notPaidyetTF.isEnabled = false
            paidTF.isEnabled = false
            saveBtn.isHidden = true
        }
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        getTokenReq()
    }
    @objc func textFieldDidChange(sender: UITextField){
        
        let formatter: NumberFormatter = NumberFormatter()
        formatter.locale = NSLocale(localeIdentifier: "EN") as Locale?
        let final = formatter.number(from: totalPaidTF.text ?? "")
        
        num1 = Double(final ?? 0)
        num2 = 0.0
        if(paidTF.text == ""){
            num2 = 0.0
        }else{
            let final1 = formatter.number(from: paidTF.text!)
            num2 = Double(final1 ?? 0)
        }
        let result = Double(num1) - Double(num2)
        notPaidyetTF.text = "\(result)"
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    @IBAction func cancelButton(_ sender: UIButton) {
        self.totalPaidTF.text = self.paisData[0]
        self.paidTF.text =  self.paisData[1]
        self.notPaidyetTF.text = self.paisData[2]
        dismiss(animated: true)
    }
    @IBAction func saveButton(_ sender: UIButton) {
        saveBtn.startAnimation()
        if(totalPaidTF.text! == ""){
            self.saveBtn.stopAnimation()
            JSSAlertView().danger(self, title: "عذرا", text: "برجاء ادخال أجمالى المبلغ", buttonText: "موافق")
        }else if(paidTF.text! == ""){
            self.saveBtn.stopAnimation()
            JSSAlertView().danger(self, title: "عذرا", text: "برجاء ادخال الدفع المقدمه", buttonText: "موافق")
        }
        else if((Int(num1)) < (Int(num2))){
            self.saveBtn.stopAnimation()
            JSSAlertView().danger(self, title: "عذرا", text: "برجاءالإدخال بطريقه صحيحه", buttonText: "موافق")
        }
        else{
            let alertview = JSSAlertView().info(self,title: "تنبيه !",text: "هل تريد حفظ التعديلات ؟",
                            buttonText: "موافق",cancelButtonText: "إلغاء" )
            alertview.addAction {
                self.editPaidProjectReq()
            }
            alertview.addCancelAction {
                self.saveBtn.stopAnimation()
                print("cancel")
            }
        }
    }
    func editPaidProjectReq(){
        let formatter: NumberFormatter = NumberFormatter()
        formatter.locale = NSLocale(localeIdentifier: "EN") as Locale?
        let final = formatter.number(from: totalPaidTF.text ?? "")
        
        num1 = Double(final ?? 0)
        num2 = 0.0
        if(paidTF.text == ""){
            num2 = 0.0
        }else{
            let final1 = formatter.number(from: paidTF.text!)
            num2 = Double(final1 ?? 0)
        }
        let result = Double(num1) - Double(num2)
        notPaidyetTF.text = "\(result)"
        print("num1 \(num1)")
        print("num2 \(num2)")
        let userId = UserDefaults.standard.value(forKey: "userId") as? String
        NetworkClient.performRequest(ViewPaidProjectModel.self, router:.edit_paid_project(emp_id: userId!, project_id: projectID, paid: "\(num1)" , paid_down: "\(num2)", paid_term: notPaidyetTF.text ?? "") ,success: { [weak self] (models) in
            if(models.status == 1){
                self?.paisData[0] = models.data[0].paid
                self?.paisData[1] = models.data[0].paidDown
                self?.paisData[2] = models.data[0].paidTerm
                self?.totalPaidTF.text = "\(models.data[0].paid)"
                self?.paidTF.text = "\(models.data[0].paidDown)"
                self?.notPaidyetTF.text = "\(models.data[0].paidTerm)"
//                self!.viewPaidProject.isHidden = true
                self?.saveBtn.stopAnimation()
                let alertview = JSSAlertView().success(self!,title : "حسنا",text: "تم التعديل بنجاح", buttonText: "موافق")
                alertview.addAction {
                   self!.dismiss(animated: true)
                }
            }
            else if (models.status == 0 ){
                self?.saveBtn.stopAnimation()
                JSSAlertView().danger(self!, title : "عذرا", text: "\(models.arMsg)", buttonText: "موافق")
            }
        }){ [weak self] (error) in
            self?.saveBtn.stopAnimation()
                JSSAlertView().danger(self!, title : "عذرا", text: "تأكد من اتصالك بالانترنت", buttonText: "موافق")
            }
    }
    func openPaidProjectReq(){
        NetworkClient.performRequest(ViewPaidProjectModel.self, router:.view_paid_project(id: projectID) ,success: { [weak self] (models) in
            print("models\( models)")
            
            if(models.status == 1){
                self?.totalPaidTF.text = "\(models.data[0].paid)"
                self?.paidTF.text = "\(models.data[0].paidDown)"
                self?.notPaidyetTF.text = "\(models.data[0].paidTerm)"
                self?.paisData[0] = models.data[0].paid
                self?.paisData[1] = models.data[0].paidDown
                self?.paisData[2] = models.data[0].paidTerm
                self?.num1 = Double((self?.totalPaidTF.text)!) as! Double
                self?.num2 = Double((self?.paidTF.text)!) as! Double
            }
            else if (models.status == 0 ){
                JSSAlertView().danger(self!, title: "عذرا", text: "حدث حطأ ما حاول مره اخري", buttonText: "موافق")
            }
        }){ [weak self] (error) in
                JSSAlertView().danger(self!, title: "عذرا", text: "تأكد من اتصالك بالانترنت", buttonText: "موافق")
        }
    }
    
}
//MARK: - UITextView Delegate
extension PaidVC{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
}
//MARK: - UITextFieldDelegate
extension PaidVC{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
          self.view.endEditing(true)
          return true
    }
}
