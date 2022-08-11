//
//  ReportTasksVC.swift
//  AL-HHALIL
//
//  Created by Sayed Abdo on 8/28/20.
//  Copyright © 2020 Sayed Abdo. All rights reserved.
//

import UIKit
import JSSAlertView

class ReportTasksVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var reportsExpan = [ReportExplanDatum]()
    var allReportsExpan : ReportExplan?
    
    @IBOutlet weak var empName: UILabel!
    
    @IBOutlet weak var fromDateLabel: UILabel!
    @IBOutlet weak var toDateLabel: UILabel!
    @IBOutlet weak var totalTasksLabel: UILabel!
    
    var toDate : String!
    var fromDate : String!
    var empString : String!
    var selectedEmpid  : String!
    
    
    var currentPage = 0
    
     override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
         config()
    }
    override func viewWillAppear(_ animated: Bool) {
        getTokenReq()
    }
    func config(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.registerHeaderNib(cellClass: newOrderTitleCell.self)
        
        empName.text = "اسم الموظف :  \(empString ?? "")"
        fromDateLabel.text = "الفتره من :  \(fromDate ?? "")"
        toDateLabel.text = "إلي :  \(toDate ?? "")"
        let total = allReportsExpan?.config?.totalRows
        totalTasksLabel.text = "إجمالى المهام خلال الفتره :  \(total!) مهمه"
    }
}
// table View
extension ReportTasksVC : UITableViewDelegate , UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reportsExpan.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReportTasksCell", for: indexPath) as! ReportTasksCell
        cell.commentLabel.text = "التفاصيل : " + (reportsExpan[indexPath.row].comments ?? "")
        cell.operationNameLabel.text = "اسم العمليه : " + (reportsExpan[indexPath.row].title ?? "")
        cell.timeLabel.text = (reportsExpan[indexPath.row].date ?? "") + "  " + (reportsExpan[indexPath.row].time ?? "")
        cell.projectNameLabel.text = reportsExpan[indexPath.row].projectName
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
       if(allReportsExpan?.config?.totalRows ?? 0 > 10){
            if indexPath.row == (reportsExpan.count) - 1 {
                if(currentPage == (allReportsExpan?.config?.numLinks)! - 1){
                }else{
                    currentPage = currentPage + 1
                    reportGetExplanReq()
                }
            }
       }
    }

}

extension ReportTasksVC{
    func reportGetExplanReq(){
        NetworkClient.performRequest(ReportExplan.self, router: .reportGetExplan(project_id : "0" ,emp_id : selectedEmpid!,date_in: fromDate! , date_out: toDate!, page: "\(currentPage)" ), success: { [weak self] (models) in
            print("models\( models.data)")
            self?.allReportsExpan = models
            if(models.status == 1){
                for reportsCounter in models.data!{
                    self?.reportsExpan.append(reportsCounter)
                }
                self?.tableView.isHidden = false
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

