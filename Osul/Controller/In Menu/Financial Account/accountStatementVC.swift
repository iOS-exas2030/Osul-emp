//
//  accountStatementVC.swift
//  AL-HHALIL
//
//  Created by apple on 9/7/20.
//  Copyright © 2020 Sayed Abdo. All rights reserved.
//

import UIKit
import JSSAlertView


class accountStatementVC: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var projectNameLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var currentMoneyTF: UITextField!
    @IBOutlet weak var debtorTF: UITextField!
    @IBOutlet weak var creditorTF: UITextField!
    
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var thirdLabel: UILabel!
    
    var model : [Daen?] = []
    var allFinancialClientSearchModel: financialClientSearchModel?
    var model2 = [FinancialProjectSearchModelDaen]()
    var alDean :FinancialProjectSearchModel?
    var check = ""
    var projectName = ""
    var fromDate = ""
    var toDate = ""
    var totaldean : Double = 0
    var totalmadeen : Double = 0
    var totalAmount = ""
    var madeeCount = 0
    
    var currentPage = 0

    
    var clientMAdeen = ""
    
    var seletectedProject = ""
    
    var financial :FinancialProjectSearchModel?
    
    var myNewView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
         config()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.getTokenReq()
    }
    func config(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.registerHeaderNib(cellClass: financialCell.self)
        
        if check == "1"{
            firstLabel.text = "اجمالي مدين"
            secondLabel.text = "اجمالي دائن"
            thirdLabel.text = "الرصيد الحالي"
            titleLabel.text = "كشف حساب عميل"
            projectNameLabel.text = projectName
            durationLabel.text = "خلال الفتره من \(fromDate) الي \(toDate)"
            debtorTF.text = String(clientMAdeen)
            creditorTF.text = String(totaldean)
            let num1 = Double(clientMAdeen)
            let num2 = Double(totaldean)
            let result = Double(num1 ?? 0.0) - Double(num2)
            currentMoneyTF.text = "\(result)"
        }else if check == "2"{
            firstLabel.text = "اجمالي المدفوعات"
            secondLabel.text = "اجمالي المصروفات"
            thirdLabel.text = "صافي المشروع"
            titleLabel.text = "كشف حساب مصروفات المشروع"
            projectNameLabel.text = projectName
            durationLabel.text = "خلال الفتره من \(fromDate) الي \(toDate)"
            debtorTF.text = String(totalmadeen)
            creditorTF.text = String(totaldean)
            let num1 = Double(totalmadeen)
            let num2 = Double(totaldean)
            let result = Double(num1) - Double(num2)
            currentMoneyTF.text = "\(result)"
        }
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
extension accountStatementVC : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
         let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "financialCell") as! financialCell
         return header
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
      return 50
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if check == "1"{
            print(" model111.count : \( model.count)")
            return  model.count
        }else {
            print(" model22.count : \( model2.count)")
            return  model2.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        let cell = tableView.dequeueReusableCell(withIdentifier: "accountCell", for: indexPath) as! accountCell
        if check == "1"{
            if(model[indexPath.row]?.id == "1" && model[indexPath.row]?.details == "قيمة التعاقد"){
                let dateCreate = model[indexPath.row]?.date?.components(separatedBy: " ")
                cell.dateLabel.text = dateCreate?[0]
                cell.statementLabel.text = model[indexPath.row]?.details
                cell.daenLabel.text = "0"
                cell.madenLabel.text = model[indexPath.row]?.amount
                cell.numberLabel.text = "\(indexPath.row + 1)"
            }else if(model[indexPath.row]?.id == "2" && model[indexPath.row]?.details == "دفعه مقدمه"){
                let dateCreate =  model[indexPath.row]?.date?.components(separatedBy: " ")
                cell.dateLabel.text = dateCreate?[0]
                cell.statementLabel.text = model[indexPath.row]?.details
                cell.daenLabel.text = model[indexPath.row]?.amount
                cell.madenLabel.text = "0"
                cell.numberLabel.text = "\(indexPath.row + 1)"
            }else{
                cell.dateLabel.text =  "\(self.getDateFromTimeStamp(timeStamp : Double((model[indexPath.row]?.date)!)!))"
                cell.statementLabel.text = model[indexPath.row]?.details
                cell.daenLabel.text = model[indexPath.row]?.amount
                cell.madenLabel.text = clientMAdeen
                cell.numberLabel.text = "\(indexPath.row + 1)"
            }
        }else{
            if(model2[indexPath.row].id == "1" && model2[indexPath.row].details == "دفعه مقدمه"){
                let dateCreate =  model2[indexPath.row].date?.components(separatedBy: " ")
                cell.dateLabel.text = dateCreate?[0]
                cell.statementLabel.text = model2[indexPath.row].details
                cell.numberLabel.text = "\(indexPath.row + 1)"
                cell.daenLabel.text = model2[indexPath.row].amount
                cell.madenLabel.text = "0"
            }else{
                cell.dateLabel.text = "\(self.getDateFromTimeStamp(timeStamp : Double((model2[indexPath.row].date)!)!))"
                cell.statementLabel.text = model2[indexPath.row].details
                cell.numberLabel.text = "\(indexPath.row + 1)"
                if madeeCount + 1 ==  indexPath.row + 1 {
                    cell.daenLabel.text = model2[indexPath.row].amount
                    cell.madenLabel.text = "0"
                }else {
                    cell.madenLabel.text = model2[indexPath.row].amount
                    cell.daenLabel.text = "0"
                }
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
                if check == "1"{
                    if(allFinancialClientSearchModel?.config?.totalRows ?? 0 > 10){
                        if indexPath.row == (model.count) - 1 {
                            if(currentPage == (allFinancialClientSearchModel?.config?.numLinks)! - 1){
                            }else{
                                currentPage = currentPage + 1
                                financialClientSearchReq()
                            }
                        }
                    }
                }else if check == "2"{
                    if(allFinancialClientSearchModel?.config?.totalRows ?? 0 > 10){
                        if indexPath.row == (model2.count) - 1 {
                            if(currentPage == (financial?.config?.numLinks)! - 1){
                            }else{
                                currentPage = currentPage + 1
                                financialProjectSearchReq()
                            }
                        }
                    }
                }
    }
}

extension accountStatementVC{
    func financialClientSearchReq(){
        NetworkClient.performRequest(financialClientSearchModel.self, router: .financialClientSearch(project_id: Int(seletectedProject) ?? 0, date_in: fromDate, date_out: toDate, page: "\(currentPage)"), success: { [weak self] (models) in
            print("models\( models.data)")
            self?.allFinancialClientSearchModel =  models
            if(models.status == 1){
//                for daenCounter in models.data[0]!.daen! {
//                    self?.model.append(daenCounter)
//                }
                self?.model = models.data[0]!.daen!
                self?.tableView.reloadData()
            }
            else if (models.status == 0 ){
                JSSAlertView().danger(self!, title: "عذرا", text: "حدث حطأ ما حاول مره اخري", buttonText: "موافق")
            }
        }){ [weak self] (error) in
            JSSAlertView().danger(self!, title: "عذرا", text: "تأكد من اتصالك بالانترنت", buttonText: "موافق")
        }
    }
    
    func financialProjectSearchReq(){
        NetworkClient.performRequest(FinancialProjectSearchModel.self, router: .financialProjectSearch(project_id: Int(seletectedProject) ?? 0, date_in:fromDate, date_out:  toDate, page: "\(currentPage)"), success: { [weak self] (models) in
            self?.financial = models
            print("models\( models.data)")
            if(models.status == 1){
                
                var model2 = [FinancialProjectSearchModelDaen]()
                model2 = models.data[0]!.maaden
                model2.append(contentsOf: models.data[0]!.daen)
                
                for madeenCounter in model2 {
                    self?.model2.append(madeenCounter)
                }
                self?.tableView.reloadData()
            }
            else if (models.status == 0 ){
                JSSAlertView().danger(self!, title: "عذرا", text: "حدث حطأ ما حاول مره اخري", buttonText: "موافق")
            }
        }){ [weak self] (error) in
            JSSAlertView().danger(self!, title: "عذرا", text: "تأكد من اتصالك بالانترنت", buttonText: "موافق")
        }
    }
}
