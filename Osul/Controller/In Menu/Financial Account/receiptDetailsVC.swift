//
//  receiptDetailsVC.swift
//  AL-HHALIL
//
//  Created by apple on 8/22/20.
//  Copyright © 2020 Sayed Abdo. All rights reserved.
//

import UIKit
import DLRadioButton
import JSSAlertView
import TransitionButton


class receiptDetailsVC: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var receiptDate: UITextField!
    @IBOutlet weak var price: UITextField!
    @IBOutlet weak var details: UITextField!
    @IBOutlet weak var receipNumber: UITextField!
    var names = [String]()
    var seletectedProject : String? = nil
    var seletectedName : String? = nil

    @IBOutlet weak var projectName: DropDown!
    
    @IBOutlet weak var receiptNumberView: UIView!
    
    var addNew : Bool!
    var getProject : FinancialProject?
    
    @IBOutlet weak var editAndDeleteStack: UIStackView!
    @IBOutlet weak var addBtn: TransitionButton!
    @IBOutlet weak var cash: DLRadioButton!
    @IBOutlet weak var banky: DLRadioButton!
    var typeNum : Int!
    let date = Date()
    let formatter = DateFormatter()
    var oneReceipt : FinancialIncomeDatum!    
    var reqesrType : Int!
    var myNewView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        config()
        getTokenReq()
    }
    func config(){
        showLoader(mainView: &myNewView)
        formatter.dateFormat = "yyyy-MM-dd"
        let result = formatter.string(from: date)
        receiptDate.isEnabled = false
        if(addNew == true){
            receiptNumberView.isHidden = true
            cash.isSelected = true
            typeNum = 1
            receiptDate.text = result
            editAndDeleteStack.isHidden = true
            if(self.reqesrType == 1){
                titleLabel.text = " الحسابات الماليه / سند قبض"
            }else{
                titleLabel.text = " الحسابات الماليه / سند صرف"
            }
        }else{
            receiptNumberView.isHidden = false
            receipNumber.isEnabled = false
            price.text = oneReceipt.amount
            details.text = oneReceipt.details
            receipNumber.text = oneReceipt.id
            receiptDate.text = "\(self.getDateFromTimeStamp(timeStamp : Double(oneReceipt.date)!))"
            if(oneReceipt.type == "1"){
               cash.isSelected = true
                typeNum = 1
            }else{
                banky.isSelected = true
                typeNum = 2
            }
            addBtn.isHidden = true
            self.seletectedProject = oneReceipt.projectID
            projectName.text = oneReceipt.projectName
            if(self.reqesrType == 1){
                titleLabel.text = " الحسابات الماليه / سند قبض /\(oneReceipt.projectName)"
            }else{
                titleLabel.text = " الحسابات الماليه / سند صرف \(oneReceipt.projectName) "
            }
        }
        financialGetProject()
        projectName.selectedRowColor = #colorLiteral(red: 0.3960784314, green: 0.1843137255, blue: 0.5568627451, alpha: 1)
        projectName.rowHeight = 50
        self.projectName.didSelect{(selectedText , index ,id) in
            self.seletectedProject = self.getProject?.data?.projects?[index].id ?? ""
            self.seletectedName  = self.getProject?.data?.projects?[index].name ?? ""
        }
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    @IBAction func addAction(_ sender: Any) {
        if(price.text == ""){
            JSSAlertView().danger(self, title: "خطأ", text: "برجاء ادخال عنوان السند ", buttonText: "موافق")
        }else if(details.text == ""){
             JSSAlertView().danger(self, title: "خطأ", text: "برجاء ادخال البيان", buttonText: "موافق")
        }else{
            if(reqesrType == 1){
                FinancialAddIncomeReq()
            }else{
                FinancialAddOutcomeReq()
            }
        }
    }
    @IBAction func byBankAction(_ sender: Any) {
        cash.isSelected = false
        banky.isSelected = true
        typeNum = 2
    }
    @IBAction func byCashAction(_ sender: Any) {
        banky.isSelected = false
        cash.isSelected = true
        typeNum = 1
    }
    @IBAction func deleteAction(_ sender: Any) {
        let alertview = JSSAlertView().warning(self,title: "تنبيه !",text: "هل تريد حذف السند ؟ ",
                        buttonText: "موافق",cancelButtonText: "إلغاء" )
        alertview.addAction {
            if(self.reqesrType == 1){
                self.FinancialRemoveIncomeReq()
            }else{
                self.FinancialRemoveOutcomeReq()
            }
        }
        alertview.addCancelAction {
            print("cancel")
        }
    }
    @IBAction func editAction(_ sender: Any) {
        if(price.text == ""){
            JSSAlertView().danger(self, title: "خطأ", text: "برجاء ادخال عنوان السند ", buttonText: "موافق")
        }else if(details.text == ""){
             JSSAlertView().danger(self, title: "خطأ", text: "برجاء ادخال البيان ", buttonText: "موافق")
        }else{
            let alertview = JSSAlertView().info(self,title: "تنبيه !",text: "هل تريد حفظ التعديلات ؟",
                            buttonText: "موافق",cancelButtonText: "لاحقا" )
            alertview.addAction {
                if(self.reqesrType == 1){
                   self.FinancialEditIncomeReq()
                }else{
                   self.FinancialEditOutcomeReq()
                }
            }
            alertview.addCancelAction {
                print("cancel")
            }
        }
    }
}
//requests
extension receiptDetailsVC{
    func FinancialAddIncomeReq(){
        let formatter: NumberFormatter = NumberFormatter()
        formatter.locale = NSLocale(localeIdentifier: "EN") as Locale?
        let final = formatter.number(from: price.text!)
        NetworkClient.performRequest(FinancialAddIncome.self, router: .financialAddIncome(project_id: seletectedProject!, amount: "\(final!)", details: details.text!, type: "\(typeNum!)"), success: { [weak self] (models) in
            print("models\( models.data)")
            if(models.status == 1){
                let view = self?.storyboard?.instantiateViewController(withIdentifier: "receiptVC") as! receiptVC
                view.reqesrType = self!.reqesrType
                self?.navigationController?.popViewController(animated: true)
            }
            else if (models.status == 0 ){
                JSSAlertView().danger(self!, title: "عذرا", text: "حدث حطأ ما حاول مره اخري", buttonText: "موافق")
            }
        }){ [weak self] (error) in
                JSSAlertView().danger(self!, title: "عذرا", text: "تأكد من اتصالك بالانترنت", buttonText: "موافق")
        }
    }
    func financialGetProject(){
        NetworkClient.performRequest(FinancialProject.self, router: .financialGetProjects, success: { [weak self] (models) in
            print("models\( models.data)")
            self?.getProject = models
            if(models.status == 1){
                for projests in (models.data?.projects)! {
                    self?.names.append(projests.name ?? "")
                }
                self?.projectName.optionArray = self?.names ?? [""]
                self!.hideLoader(mainView: &self!.myNewView)
            }
            else if (models.status == 0 ){
                JSSAlertView().danger(self!, title: "عذرا", text: "حدث حطأ ما حاول مره اخري", buttonText: "موافق")
            }
        }){ [weak self] (error) in
            JSSAlertView().danger(self!, title: "عذرا", text: "تأكد من اتصالك بالانترنت", buttonText: "موافق")
        }
    }
    func FinancialRemoveIncomeReq(){
        NetworkClient.performRequest(statusModel.self, router: .FinancialRemoveIncome(id: "\(oneReceipt.id)"), success: { [weak self] (models) in
            print("models\( models.data)")
            if(models.status == 1){
                let view = self?.storyboard?.instantiateViewController(withIdentifier: "receiptVC") as! receiptVC
                view.reqesrType = self!.reqesrType
                self?.navigationController?.popViewController(animated: true)
            }
            else if (models.status == 0 ){
                JSSAlertView().danger(self!, title: "عذرا", text: "حدث حطأ ما حاول مره اخري", buttonText: "موافق")
            }
        }){ [weak self] (error) in
                JSSAlertView().danger(self!, title: "عذرا", text: "تأكد من اتصالك بالانترنت", buttonText: "موافق")
        }
    }
    func FinancialEditIncomeReq(){
        let formatter: NumberFormatter = NumberFormatter()
        formatter.locale = NSLocale(localeIdentifier: "EN") as Locale?
        let final = formatter.number(from: price.text!)
        NetworkClient.performRequest(FinancialAddIncome.self, router: .financialEditIncome(editid: oneReceipt.id, project_id: seletectedProject!, amount: "\(final!)", details: details.text!, type: "\(typeNum!)"), success: { [weak self] (models) in
            print("models\( models.data)")
            if(models.status == 1){
                let view = self?.storyboard?.instantiateViewController(withIdentifier: "receiptVC") as! receiptVC
                view.reqesrType = self!.reqesrType
                self?.navigationController?.popViewController(animated: true)
            }
            else if (models.status == 0 ){
                JSSAlertView().danger(self!, title: "عذرا", text: "حدث حطأ ما حاول مره اخري", buttonText: "موافق")
            }
        }){ [weak self] (error) in
                JSSAlertView().danger(self!, title: "عذرا", text: "تأكد من اتصالك بالانترنت", buttonText: "موافق")
        }
    }
    func FinancialAddOutcomeReq(){
        let formatter: NumberFormatter = NumberFormatter()
        formatter.locale = NSLocale(localeIdentifier: "EN") as Locale?
        let final = formatter.number(from: price.text!)
        
        NetworkClient.performRequest(FinancialAddIncome.self, router: .FinancialAddOutcome(project_id: seletectedProject!, amount: "\(final!)", details: details.text!, type: "\(typeNum!)"), success: { [weak self] (models) in
            print("models\( models.data)")
            if(models.status == 1){
                let view = self?.storyboard?.instantiateViewController(withIdentifier: "receiptVC") as! receiptVC
                view.reqesrType = self!.reqesrType
                self?.navigationController?.popViewController(animated: true)
            }
            else if (models.status == 0 ){
                JSSAlertView().danger(self!, title: "عذرا", text: "حدث حطأ ما حاول مره اخري", buttonText: "موافق")
            }
        }){ [weak self] (error) in
            JSSAlertView().danger(self!, title: "عذرا", text: "تأكد من اتصالك بالانترنت", buttonText: "موافق")
        }
    }
    func FinancialRemoveOutcomeReq(){
       NetworkClient.performRequest(statusModel.self, router: .FinancialRemoveOutcome(id: "\(oneReceipt.id)"), success: { [weak self] (models) in
            print("models\( models.data)")
            if(models.status == 1){
                let view = self?.storyboard?.instantiateViewController(withIdentifier: "receiptVC") as! receiptVC
                view.reqesrType = self!.reqesrType
                self?.navigationController?.popViewController(animated: true)
            }
            else if (models.status == 0 ){
                JSSAlertView().danger(self!, title: "عذرا", text: "حدث حطأ ما حاول مره اخري", buttonText: "موافق")
            }
        }){ [weak self] (error) in
            JSSAlertView().danger(self!, title: "عذرا", text: "تأكد من اتصالك بالانترنت", buttonText: "موافق")
        }
    }
    func FinancialEditOutcomeReq(){
        let formatter: NumberFormatter = NumberFormatter()
        formatter.locale = NSLocale(localeIdentifier: "EN") as Locale?
        let final = formatter.number(from: price.text!)
        
        NetworkClient.performRequest(FinancialAddIncome.self, router: .financialEditOutcome(editid: oneReceipt.id, project_id: seletectedProject!, amount: "\(final!)", details: details.text!, type: "\(typeNum!)"), success: { [weak self] (models) in
            print("models\( models.data)")
            if(models.status == 1){
                let view = self?.storyboard?.instantiateViewController(withIdentifier: "receiptVC") as! receiptVC
                view.reqesrType = self!.reqesrType
                self?.navigationController?.popViewController(animated: true)
            }
            else if (models.status == 0 ){
                JSSAlertView().danger(self!, title: "عذرا", text: "حدث حطأ ما حاول مره اخري", buttonText: "موافق")
            }
        }){ [weak self] (error) in
                JSSAlertView().danger(self!, title: "عذرا", text: "تأكد من اتصالك بالانترنت", buttonText: "موافق")
        }
    }
}
extension Date {
    var millisecondsSince1970:Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    init(milliseconds:Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
}

