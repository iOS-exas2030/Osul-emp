//
//  ClientAccountStatementVC.swift
//  AL-HHALIL
//
//  Created by apple on 9/7/20.
//  Copyright © 2020 Sayed Abdo. All rights reserved.
//

import UIKit
import JSSAlertView

class ClientAccountStatementVC: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var projectNameTF: DropDown!
    @IBOutlet weak var fromDateTF: UITextField!
    @IBOutlet weak var toDateTF: UITextField!
    var names = [String]()
    var seletectedProject : String? = nil
    var seletectedName : String? = nil
    let  toDatePicker = UIDatePicker()
    let  fromDatePicker = UIDatePicker()
    var checkVC = ""
    var getProject : FinancialProject?
    var financial :FinancialProjectSearchModel?
    var totalPricedean : Double = 0
    var totalPricemadean : Double = 0
    var myNewView = UIView()
    
    var model : [Daen?] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        config()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.getTokenReq()
    }
    func config(){
        showLoader(mainView: &myNewView)
        financialGetProject()
        projectNameTF.selectedRowColor = #colorLiteral(red: 0.3960784314, green: 0.1843137255, blue: 0.5568627451, alpha: 1)
        projectNameTF.rowHeight = 50
        self.projectNameTF.didSelect{(selectedText , index ,id) in
            self.seletectedProject = self.getProject?.data?.projects?[index].id ?? ""
            self.seletectedName  = self.getProject?.data?.projects?[index].name ?? ""
        }
        self.showToDatePicker()
        self.showFromDatePicker()
        totalPricedean  = 0
        totalPricemadean  = 0
        if(checkVC == "1"){
            titleLabel.text = "الحسابات الماليه / كشف حساب عميل"
        }else{
            titleLabel.text = "الحسابات الماليه / كشف حساب مصروفات مشروع"
        }
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    @IBAction func showButton(_ sender: UIButton) {
        if(seletectedProject == nil){
            JSSAlertView().danger(self, title: "خطأ", text: "برجاء تحديد المشروع اولا", buttonText: "موافق")
        }else if checkVC == "1"{
            financialClientSearchReq()
        }else if checkVC == "2"{
            financialProjectSearchReq()
        }
    }
    func showToDatePicker(){
        //Formate Date
        toDatePicker.datePickerMode = .date
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        toolbar.tintColor = UIColor.black
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        toDateTF.inputAccessoryView = toolbar
        toDateTF.inputView = toDatePicker
    }
    func showFromDatePicker(){
        //Formate Date
        fromDatePicker.datePickerMode = .date
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        toolbar.tintColor = UIColor.black
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donetimePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        fromDateTF.inputAccessoryView = toolbar
        fromDateTF.inputView = fromDatePicker
    }
    @objc func donedatePicker(){
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        toDateTF.text = formatter.string(from: toDatePicker.date)
        self.view.endEditing(true)
    }
    @objc func donetimePicker(){
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        fromDateTF.text = formatter.string(from: fromDatePicker.date)
        self.view.endEditing(true)
    }
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
}
extension ClientAccountStatementVC {
    func financialGetProject(){
        NetworkClient.performRequest(FinancialProject.self, router: .financialGetProjects, success: { [weak self] (models) in
            self?.getProject = models
            print("models\( models.data)")
            if(models.status == 1){
                for projests in (models.data?.projects)! {
                    self?.names.append(projests.name ?? "")
//                  self!.AllstateArray.append(StatesDatum(id: statesCounter.id, title: statesCounter.title))
//                  if ( self?.clientData?.state == projests.id){
//                      self?.stateDropDown.text = pro.title
//                  }
                }
                self?.projectNameTF.optionArray = self?.names ?? [""]
                self!.hideLoader(mainView: &self!.myNewView)
            }
            else if (models.status == 0 ){
                JSSAlertView().danger(self!, title: "عذرا", text: "حدث حطأ ما حاول مره اخري", buttonText: "موافق")
            }
        }){ [weak self] (error) in
            JSSAlertView().danger(self!, title: "عذرا", text: "تأكد من اتصالك بالانترنت", buttonText: "موافق")
        }
    }
    func financialClientSearchReq(){
        NetworkClient.performRequest(financialClientSearchModel.self, router: .financialClientSearch(project_id: Int(seletectedProject ?? "") ?? 0, date_in: fromDateTF.text ?? "", date_out: toDateTF.text ?? "", page: "0"), success: { [weak self] (models) in
            print("models\( models.data)")
            if(models.status == 1){
                self?.model.append(Daen(id: "1", projectID: "", projectName: models.data[0]?.proTitle, date: models.data[0]?.proDate, amount: models.data[0]?.contractPaid, details: "قيمة التعاقد", type: ""))
                self?.model.append(Daen(id: "2", projectID: "", projectName: models.data[0]?.proTitle, date: models.data[0]?.proDate, amount: models.data[0]?.contractDwon, details: "دفعه مقدمه", type: ""))
                for daenCounter in models.data[0]!.daen! {
                    self?.model.append(daenCounter)
                }
             //   self?.model = models.data[0]!.daen!
                let view = self?.storyboard?.instantiateViewController(withIdentifier: "accountStatementVC") as! accountStatementVC
                view.model = self?.model ?? []
                view.check = self?.checkVC ?? ""
                view.projectName = self?.seletectedName ?? ""
                view.fromDate = self?.fromDateTF.text ?? ""
                view.toDate = self?.toDateTF.text ?? ""
                view.totaldean = Double(models.data[0]?.totalDaen ?? "0.0")! + Double(models.data[0]?.contractDwon ?? "0.0")!
                view.totalAmount = models.data[0]!.contractPaid ?? ""
                view.clientMAdeen = (models.data[0]?.contractPaid)!
                view.seletectedProject = self?.seletectedProject ?? ""
                view.allFinancialClientSearchModel = models
              //  view.totalmadeen = self?.totalPricemadean ?? 0
                self?.navigationController?.pushViewController(view, animated: true)
            }
            else if (models.status == 0 ){
                JSSAlertView().danger(self!, title: "عذرا", text: "حدث حطأ ما حاول مره اخري", buttonText: "موافق")
            }
        }){ [weak self] (error) in
            JSSAlertView().danger(self!, title: "عذرا", text: "تأكد من اتصالك بالانترنت", buttonText: "موافق")
        }
    }
    func financialProjectSearchReq(){
        NetworkClient.performRequest(FinancialProjectSearchModel.self, router: .financialProjectSearch(project_id: Int(seletectedProject ?? "") ?? 0, date_in:fromDateTF.text ?? "", date_out:  toDateTF.text ?? "", page: "0"), success: { [weak self] (models) in
            self?.financial = models
            print("models\( models.data)")
            if(models.status == 1){
                let view = self?.storyboard?.instantiateViewController(withIdentifier: "accountStatementVC") as! accountStatementVC
               // models.data[0]!.maaden.append(models.data[0]!.daen)
                view.madeeCount = models.data[0]!.maaden.count
                var model2 = [FinancialProjectSearchModelDaen]()
                model2.append(FinancialProjectSearchModelDaen(id: "1", projectID: "", projectName:models.data[0]!.proTitle, date: models.data[0]!.proDate, amount: models.data[0]!.contractDwon, details: "دفعه مقدمه", type: ""))
              //  model2 = models.data[0]!.maaden
                 model2.append(contentsOf: models.data[0]!.maaden)
                model2.append(contentsOf: models.data[0]!.daen)
                view.model2 = model2
               // view.model2.append(models.data[0]!.daen)
                view.check = self?.checkVC ?? ""
                view.projectName = self?.seletectedName ?? ""
                view.fromDate = self?.fromDateTF.text ?? ""
                view.toDate = self?.toDateTF.text ?? ""
                view.alDean = self?.financial                
                view.totalmadeen = Double(models.data[0]!.totalInComes ?? "0.0")! + Double(models.data[0]?.contractDwon ?? "0.0")!
                view.totaldean = Double(models.data[0]!.totalOutComes ?? "0.0")!
                view.totalAmount = models.data[0]!.contractPaid ?? ""
                view.totalAmount = "\(Double(models.data[0]!.totalInComes ?? "0.0")! - Double(models.data[0]!.totalOutComes ?? "0.0")!)"
                self?.navigationController?.pushViewController(view, animated: true)
            }
            else if (models.status == 0 ){
                JSSAlertView().danger(self!, title: "عذرا", text: "حدث حطأ ما حاول مره اخري", buttonText: "موافق")
            }
        }){ [weak self] (error) in
            JSSAlertView().danger(self!, title: "عذرا", text: "تأكد من اتصالك بالانترنت", buttonText: "موافق")
        }
    }
}
