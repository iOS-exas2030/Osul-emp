//
//  ReportsAndStatisticsVC.swift
//  AL-HHALIL
//
//  Created by Sayed Abdo && Aya Bahaa on 7/3/20.
//  Copyright © 2020 Sayed Abdo && Aya Bahaa. All rights reserved.
//

import UIKit
import JSSAlertView
import SideMenu
import TransitionButton

class ReportsAndStatisticsVC: UIViewController {
     
     @IBOutlet weak var reportsAndStatisticsTableView: UITableView!
     var reportsAndStatisticsArr = [ReportsAndStatistics]()
     var menu : SideMenuNavigationController?
     var popstatus = 1
    
    @IBOutlet weak var popViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var employeeNameView: UIView!
    @IBOutlet weak var employeeName: DropDown!

    
    @IBOutlet weak var PopView: UIView!
    @IBOutlet weak var dateFromTextField: UITextField!
    @IBOutlet weak var toFromTextField: UITextField!
    @IBOutlet weak var displayBtn: TransitionButton!
    @IBOutlet weak var empName: UILabel!
    
    let  toDatePicker = UIDatePicker()
    let  fromDatePicker = UIDatePicker()
    
    @IBOutlet weak var fromDateTF: UITextField!
    @IBOutlet weak var toDateTF: UITextField!
    
    var empNameArr = [String]()
    var empArr = [AllusersModelUser]()
    
    var ArchivedProject = [ArchiveProjectDataModelDatum]()
    var reportsExpan = [ReportExplanDatum]()
    var Cons :Constants?
    
    var selectedEmp = false
    var selectedEmpId : Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let userName = UserDefaults.standard.value(forKey: "userName") as? String
        let jopTitle = UserDefaults.standard.value(forKeyPath: "jopTitle") as? String
        empName.text = " \(userName ?? "")/\(jopTitle ?? "")"
         config()
     }
    @IBAction func openProfileAction(_ sender: Any) {
        let view = storyboard?.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
        self.navigationController?.pushViewController(view, animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.getTokenReq()
    }
     func config(){
        self.reportsAndStatisticsTableView.delegate = self
        self.reportsAndStatisticsTableView.dataSource = self
        self.reportsAndStatisticsTableView.isScrollEnabled = false
        self.reportsAndStatisticsTableView.separatorColor = .clear
        // Table View Animation when load
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
            self.reportsAndStatisticsArr = [ReportsAndStatistics(imageName: "ReportsAndStatistics1", departmentName: "ارشيف المشاريع"),
                                   ReportsAndStatistics(imageName: "ReportsAndStatistics2", departmentName: "تقرير المدفوعات من العملاء"),
                                   ReportsAndStatistics(imageName: "ReportsAndStatistics5", departmentName: "تقرير المهام والانجازيه")
                                ]
            self.reportsAndStatisticsTableView.isHidden = false
            self.reportsAndStatisticsTableView.reloadData()
            self.animateTableView()
            self.PopView.isHidden = true
            let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.popViewHide))
            self.PopView.addGestureRecognizer(tap)
            self.showToDatePicker()
            self.showFromDatePicker()
            self.get_all_users()
        }
        // sideMenu
        menu = SideMenuNavigationController(rootViewController: SideMenuTableViewController())
        SideMenuManager.default.rightMenuNavigationController = menu
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
        menu?.setNavigationBarHidden(true, animated: false)
        
        self.employeeName.didSelect{(selectedText , index ,id) in
            self.selectedEmpId = index
            self.selectedEmp = true
        }
    }
    // hide Pop View
    @objc func  popViewHide (){
        PopView.isHidden = true
    }
    // side Menu Action hide and show
    @IBAction func sideMenu(_ sender: UIBarButtonItem) {
        menu = storyboard?.instantiateViewController(withIdentifier: "RightMenu") as? SideMenuNavigationController
        present(menu!, animated: true)
    }
    @IBAction func disPlayAction(_ sender: Any) {
        if(popstatus == 1){
            archiveProjectSearchReq()
        }
        if(popstatus == 2){
            //let view = storyboard?.instantiateViewController(identifier: "ReportTasksVC") as! ReportTasksVC
          //  self.navigationController?.pushViewController(view, animated: true)
            reportGetExplanReq()
        }
    }
}
// table View protocol methods
extension ReportsAndStatisticsVC :UITableViewDelegate ,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reportsAndStatisticsArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "ReportsAndStatisticsCell", for: indexPath) as! ReportsAndStatisticsCell
        cell.reportsAndStatisticsImage.image = UIImage(named: "\(reportsAndStatisticsArr[indexPath.row].imageName)")
        cell.reportsAndStatisticsName.text = reportsAndStatisticsArr[indexPath.row].departmentName
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.row == 0){
            popstatus = 1
            if(popstatus == 1){
                employeeNameView.isHidden = true
                popViewHeight.constant = 180
            }
            PopView.isHidden = false
        }else if(indexPath.row == 1){
            let view = storyboard?.instantiateViewController(withIdentifier: "paymentsReportSVC") as! paymentsReportSVC
            self.navigationController?.pushViewController(view, animated: true)
        }else if(indexPath.row == 2){
             popstatus = 2
            if(popstatus == 2){
                employeeNameView.isHidden = false
                popViewHeight.constant = 240
            }
            PopView.isHidden = false
        }
    }
}
// table view Animation
extension ReportsAndStatisticsVC{
    func animateTableView(){
        let fadeAnimation = TableViewAnimation.Cell.left(duration: 1.0)
        self.reportsAndStatisticsTableView.animate(animation: fadeAnimation)
    }
}
//Picker
extension ReportsAndStatisticsVC{
    func showToDatePicker(){
        //Formate Date
        toDatePicker.datePickerMode = .date
        //ToolBar
        let toolbar = UIToolbar()
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
        let toolbar = UIToolbar()
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
        formatter.dateFormat = "yyyy-MM-dd"
        toDateTF.text = formatter.string(from: toDatePicker.date)
        self.view.endEditing(true)
    }
    @objc func donetimePicker(){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        fromDateTF.text = formatter.string(from: fromDatePicker.date)
        self.view.endEditing(true)
    }
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
}
// Requests 
extension ReportsAndStatisticsVC{
    
    func archiveProjectSearchReq(){
        NetworkClient.performRequest(ArchiveProjectDataModel.self, router: .getArchiveProjectData( date_in: fromDateTF.text ?? "", date_out: toDateTF.text ?? "", page: "0"), success: { [weak self] (models) in
            print("models\( models.data)")
            if(models.status == 1){
                let view = self?.storyboard?.instantiateViewController(withIdentifier: "ArchiveProjectsVC") as! ArchiveProjectsVC
                
                for archivedCounter in models.data.reversed(){
                    self?.ArchivedProject.append(archivedCounter)
                }
                view.ArchivedProject = models.data
                view.fromDateTF = self?.fromDateTF.text ?? ""
                view.toDateTF = self?.toDateTF.text ?? ""
                view.allArchivedProject = models
                self?.navigationController?.pushViewController(view, animated: true)
            }
            else if (models.status == 0 ){
                JSSAlertView().warning(self!, title: "عذرا", text: "لا توجد مشاريع بالارشيف", buttonText: "موافق")
            }
        }){ [weak self] (error) in
                JSSAlertView().danger(self!, title: "عذرا", text: "تأكد من اتصالك بالانترنت", buttonText: "موافق")
        }
    }
    
    func get_all_users(){
       NetworkClient.performRequest(AllusersModel.self, router: .getAllUsersfilter, success: { [weak self] (models) in
           if(models.status == 1){
            self?.empArr = (models.data?.users)!
            for empCounter in (models.data?.users)! {
                self?.empNameArr.append(empCounter.name ?? "")
            }
            self?.employeeName.optionArray = self?.empNameArr ?? [""]
            self?.employeeName.rowHeight = 50
           }
           else if (models.status == 0 ){
            JSSAlertView().danger(self!, title: "عذرا", text: "حدث حطأ ما حاول مره اخري", buttonText: "موافق")
           }
       }){ [weak self] (error) in
            JSSAlertView().danger(self!, title: "عذرا", text: "تأكد من اتصالك بالانترنت", buttonText: "موافق")
       }
    }
    
    func reportGetExplanReq(){
        NetworkClient.performRequest(ReportExplan.self, router: .reportGetExplan(project_id : "0" ,emp_id : empArr[selectedEmpId].id!,date_in: fromDateTF.text! , date_out: toDateTF.text!, page: "0" ), success: { [weak self] (models) in
            print("models\( models.data)")
            if(models.status == 1){
                let view = self?.storyboard?.instantiateViewController(withIdentifier: "ReportTasksVC") as! ReportTasksVC
                view.empString = "\(self?.empArr[self!.selectedEmpId].name ?? "")"
                view.fromDate = self?.fromDateTF.text ?? ""
                view.toDate = self?.toDateTF.text ?? ""
                view.selectedEmpid = self?.empArr[self!.selectedEmpId].id
                for reportsCounter in models.data!{
                    self?.reportsExpan.append(reportsCounter)
                }
                view.reportsExpan = self!.reportsExpan
                view.allReportsExpan = models
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
